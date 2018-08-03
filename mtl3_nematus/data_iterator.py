import numpy

import gzip

import shuffle
from util import load_dict

def fopen(filename, mode='r'):
    if filename.endswith('.gz'):
        return gzip.open(filename, mode)
    return open(filename, mode)

class FileWrapper(object):
    def __init__(self, fname):
        self.pos = 0
        self.lines = fopen(fname).readlines()
        self.lines = numpy.array(self.lines, dtype=numpy.object)
    def __iter__(self):
        return self
    def next(self):
        if self.pos >= len(self.lines):
            raise StopIteration
        l = self.lines[self.pos]
        self.pos += 1
        return l
    def reset(self):
        self.pos = 0
    def seek(self, pos):
        assert pos == 0
        self.pos = 0
    def readline(self):
        return self.next()
    def shuffle_lines(self, perm):
        self.lines = self.lines[perm]
        self.pos = 0
    def __len__(self):
        return len(self.lines)

class TextIterator:
    """Simple Bitext iterator."""
    def __init__(self, source, target, ae_target, pos_target,
                 source_dicts, target_dict, ae_target_dict,pos_target_dict,
                 batch_size=128,
                 maxlen=100,
                 source_vocab_sizes=None,
                 target_vocab_size=None,
                 ae_target_vocab_size = None,
                 pos_target_vocab_size = None,
                 skip_empty=False,
                 shuffle_each_epoch=False,
                 sort_by_length=True,
                 use_factor=False,
                 maxibatch_size=20,
                 token_batch_size=0,
                 keep_data_in_memory=False):
        if keep_data_in_memory:
            self.source, self.target, self.ae_target, self.pos_target = FileWrapper(source), FileWrapper(target), FileWrapper(ae_target), FileWrapper(pos_target)
            if shuffle_each_epoch:
                r = numpy.random.permutation(len(self.source))
                self.source.shuffle_lines(r)
                self.target.shuffle_lines(r)
                self.ae_target.shuffle_lines(r)
                self.pos_target.shuffle_lines(r)
        elif shuffle_each_epoch:
            self.source_orig = source
            self.target_orig = target
            self.ae_target_orig = ae_target
            self.pos_target_orig = pos_target
            self.source, self.target, self.ae_target, self.pos_target = shuffle.main([self.source_orig, self.target_orig, self.ae_target_orig, self.pos_target_orig], temporary=True)
        else:
            self.source = fopen(source, 'r')
            self.target = fopen(target, 'r')
            self.ae_target = fopen(ae_target, 'r')
            self.pos_target = fopen(pos_target, 'r')
        self.source_dicts = []
        for source_dict in source_dicts:
            self.source_dicts.append(load_dict(source_dict))
        self.target_dict = load_dict(target_dict)
        self.ae_target_dict = load_dict(ae_target_dict)
        self.pos_target_dict = load_dict(pos_target_dict)
        self.keep_data_in_memory = keep_data_in_memory
        self.batch_size = batch_size
        self.maxlen = maxlen
        self.skip_empty = skip_empty
        self.use_factor = use_factor

        self.source_vocab_sizes = source_vocab_sizes
        self.target_vocab_size = target_vocab_size
        self.ae_target_vocab_size = ae_target_vocab_size
        self.pos_target_vocab_size = pos_target_vocab_size
        self.token_batch_size = token_batch_size

        if self.source_vocab_sizes != None:
            assert len(self.source_vocab_sizes) == len(self.source_dicts)
            for d, vocab_size in zip(self.source_dicts, self.source_vocab_sizes):
                if vocab_size != None and vocab_size > 0:
                    for key, idx in d.items():
                        if idx >= vocab_size:
                            del d[key]

        if self.target_vocab_size != None and self.target_vocab_size > 0:
            for key, idx in self.target_dict.items():
                if idx >= self.target_vocab_size:
                    del self.target_dict[key]

        if self.ae_target_vocab_size != None and self.ae_target_vocab_size > 0:
            for key, idx in self.ae_target_dict.items():
                if idx >= self.ae_target_vocab_size:
                    del self.ae_target_dict[key]

        if self.pos_target_vocab_size != None and self.pos_target_vocab_size > 0:
            for key, idx in self.pos_target_dict.items():
                if idx >= self.pos_target_vocab_size:
                    del self.pos_target_dict[key]
        self.shuffle = shuffle_each_epoch
        self.sort_by_length = sort_by_length

        self.source_buffer = []
        self.target_buffer = []
        self.ae_target_buffer = []
        self.pos_target_buffer = []
        self.k = batch_size * maxibatch_size


        self.end_of_data = False

    def __iter__(self):
        return self

    def reset(self):
        if self.shuffle:
            if self.keep_data_in_memory:
                r = numpy.random.permutation(len(self.source))
                self.source.shuffle_lines(r)
                self.target.shuffle_lines(r)
                self.ae_target.shuffle_lines(r)
                self.pos_target.shuffle_lines(r)
            else:
                self.source, self.target, self.ae_target, self.pos_target = shuffle.main([self.source_orig, self.target_orig, self.ae_target_orig, self.pos_target_orig], temporary=True)
        else:
            self.source.seek(0)
            self.target.seek(0)
            self.ae_target.seek(0)
            self.pos_target.seek(0)

    def next(self):
        if self.end_of_data:
            self.end_of_data = False
            self.reset()
            raise StopIteration

        source = []
        target = []
        ae_target = []
        pos_target = []

        longest_source = 0
        longest_target = 0
        longest_ae_target = 0
        longest_pos_target = 0

        # fill buffer, if it's empty
        assert len(self.source_buffer) == len(self.target_buffer), 'Buffer size mismatch!'

        if len(self.source_buffer) == 0:
            for ss in self.source:
                ss = ss.split()
                tt = self.target.readline().split()
                at = self.ae_target.readline().split()
                pt = self.pos_target.readline().split()
                if self.skip_empty and (len(ss) == 0 or len(tt) == 0 or len(at) == 0 or len(pt) == 0):
                    continue
                if len(ss) > self.maxlen or len(tt) > self.maxlen or len(at)>self.maxlen or len(pt)>self.maxlen:
                    continue

                self.source_buffer.append(ss)
                self.target_buffer.append(tt)
                self.ae_target_buffer.append(at)
                self.pos_target_buffer.append(pt)
                if len(self.source_buffer) == self.k:
                    break

            if len(self.source_buffer) == 0 or len(self.target_buffer) == 0 or len(self.ae_target_buffer)==0 or len(self.pos_target_buffer)==0:
                self.end_of_data = False
                self.reset()
                raise StopIteration

            # sort by source/target buffer length
            if self.sort_by_length:
                tlen = numpy.array([max(len(s),len(t), len(at), len(pt)) for (s,t, at, pt) in zip(self.source_buffer,self.target_buffer, self.ae_target_buffer, self.pos_target_buffer)])
                tidx = tlen.argsort()

                _sbuf = [self.source_buffer[i] for i in tidx]
                _tbuf = [self.target_buffer[i] for i in tidx]
                _atbuf = [self.ae_target_buffer[i] for i in tidx]
                _ptbuf = [self.pos_target_buffer[i] for i in tidx]
                self.source_buffer = _sbuf
                self.target_buffer = _tbuf
                self.ae_target_buffer = _atbuf
                self.pos_target_buffer = _ptbuf

            else:
                self.source_buffer.reverse()
                self.target_buffer.reverse()
                self.ae_target_buffer.reverse()
                self.pos_target_buffer.reverse()


        try:
            # actual work here
            while True:

                # read from source file and map to word index
                try:
                    ss = self.source_buffer.pop()
                except IndexError:
                    break
                tmp = []
                for w in ss:
                    if self.use_factor:
                        w = [self.source_dicts[i][f] if f in self.source_dicts[i] else 1 for (i,f) in enumerate(w.split('|'))]
                    else:
                        w = [self.source_dicts[0][w] if w in self.source_dicts[0] else 1]
                    tmp.append(w)
                ss_indices = tmp

                # read from source file and map to word index
                tt = self.target_buffer.pop()
                tt_indices = [self.target_dict[w] if w in self.target_dict else 1
                      for w in tt]
                if self.target_vocab_size != None:
                    tt_indices = [w if w < self.target_vocab_size else 1 for w in tt_indices]

                # read from source file and map to word index
                at = self.ae_target_buffer.pop()
                at_indices = [self.ae_target_dict[w] if w in self.ae_target_dict else 1
                      for w in at]
                if self.ae_target_vocab_size != None:
                    at_indices = [w if w < self.ae_target_vocab_size else 1 for w in at_indices]

                pt = self.pos_target_buffer.pop()
                pt_indices = [self.pos_target_dict[w] if w in self.pos_target_dict else 1
                      for w in pt]
                if self.pos_target_vocab_size != None:
                    pt_indices = [w if w < self.pos_target_vocab_size else 1 for w in pt_indices]

                source.append(ss_indices)
                target.append(tt_indices)
                ae_target.append(at_indices)
                pos_target.append(pt_indices)
                longest_source = max(longest_source, len(ss_indices))
                longest_target = max(longest_target, len(tt_indices))
                longest_ae_target = max(longest_ae_target, len(at_indices))
                longest_pos_target = max(longest_pos_target, len(pt_indices))
                if self.token_batch_size:
                    if len(source)*longest_source > self.token_batch_size or \
                        len(target)*longest_target > self.token_batch_size or \
                        len(ae_target)*longest_ae_target > self.token_batch_size or \
                        len(pos_target)*longest_pos_target > self.token_batch_size:
                        # remove last sentence pair (that made batch over-long)
                        source.pop()
                        target.pop()
                        ae_target.pop()
                        pos_target.pop()
                        self.source_buffer.append(ss)
                        self.target_buffer.append(tt)
                        self.ae_target_buffer.append(at)
                        self.pos_target_buffer.append(pt)

                        break

                else:
                    if len(source) >= self.batch_size or \
                        len(target) >= self.batch_size or \
                        len(ae_target) >= self.batch_size or \
                        len(pos_target) >= self.batch_size:
                        break
        except IOError:
            self.end_of_data = True

        return source, target, ae_target, pos_target
