#!/bin/bash

# process the raw tokenized data into prepared phrases
python preprocessing.py corpus/raw/ corpus/prep/;

# compute the word frequencies for each worldview file. This will give you the shared vocabularies to use for alignment
python ./src/stats/counts.py ./corpus ./data/counts.json

# a general-purpose embedding to use for word clustering. You need to choose a text file that best represents "generic" language among your communities. You could use the union of the worldview files. That's what we did, and the method implemented by multitrain.sh
# First, build the general-purpose embedding:
./src/modeling/multitrain.sh ./corpus ./data/master.model

# Then, compute the clusters: 
python ./src/stats/topics.py ./data/master.model ./data/clusters.json

# Place your preprocessed text file, each representing one worldview, into corpus/. Then
# train the fist embeddings
./src/modeling/train.sh ./corpus ./data/models
# python train.py corpus/prep/politics.txt models/politics.word2vec.model;

# train the second embeddings
# python train.py corpora/prep/the_donald.txt models/the_donald.word2vec.model;

# Run one of the following aligners:
python ./src/alignment/align.py ./data/models/ ./data/aligners/cca/ ./data/counts.json cca 1000
# python ./src/alignment/align.py ./data/models/ ./data/aligners/svd/ ./data/counts.json svd 1000 # (Khudabukhsh, et al.)
# python ./src/alignment/align.py ./data/models/ ./data/aligners/lstsq/ ./data/counts.json lstsq 1000

# Check out each of the analysis notebooks for ideas.