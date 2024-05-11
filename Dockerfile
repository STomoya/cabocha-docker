FROM python:3

RUN apt update -y && \
    DEBIAN_FRONTEND=noniteractive apt install -y \
    tar \
    wget \
    g++ \
    make \
    ca-certificates \
    git

RUN set -eux \
    # download mecab, mecab-ipadic files.
    && wget "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -O mecab.tar.gz \
    && wget "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -O mecab-ipadic.tar.gz \
    && mkdir -p /usr/src/mecab \
    && tar -xzC /usr/src/mecab -f mecab.tar.gz \
    && tar -xzC /usr/src/mecab -f mecab-ipadic.tar.gz \
    # download cabocha files
    && wget "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ" -O crf.tar.gz \
    && wget "https://drive.usercontent.google.com/download?export=download&confirm=y&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU" -O cabocha.tar.bz2 \
    && mkdir -p /usr/src/cabocha \
    && tar -xzC /usr/src/cabocha -f crf.tar.gz \
    && tar -xjC /usr/src/cabocha -f cabocha.tar.bz2

    # install mecab
RUN cd /usr/src/mecab/mecab-0.996/ \
    && ./configure --enable-utf8-only --with-charset=utf8 \
    && make \
    && make install \
    && ldconfig \
    # install ipadic
    && cd /usr/src/mecab/mecab-ipadic-2.7.0-20070801/ \
    && ./configure --enable-utf8-only --with-charset=utf8 \
    && make \
    && make install \
    # install CRF (needed for cabocha)
    && cd /usr/src/cabocha/CRF++-0.58 \
    && ./configure \
    && make \
    && make install \
    # install cabocha
    && cd /usr/src/cabocha/cabocha-0.69 \
    && ./configure --enable-utf8-only --with-charset=utf8 \
    && make \
    && make install \
    && ldconfig

    # install neologd
RUN cd /usr/src/mecab/ \
    && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && ./bin/install-mecab-ipadic-neologd -n -y

# install pip modules
COPY ./requirements.txt requirements.txt
RUN pip --default-timeout=100 install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "app.__main__:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
