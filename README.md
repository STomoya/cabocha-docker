
# cabocha-docker

Dockerfile containing [CaboCha](https://taku910.github.io/cabocha/).

## Versions

- MeCab: 0.996

- mecab-ipadic-neologd (commit): abc61e33d8be3d0ead202e6b1df064c72d5ccf11

- CRF++: 0.58

- CaboCha: 0.69

## Usage

- Build:

  ```sh
  docker compose build
  ```

- Run MeCab:

  ```sh
  $ docker compose run --rm python mecab
  吾輩はヌッコである。
  吾輩    名詞,代名詞,一般,*,*,*,吾輩,ワガハイ,ワガハイ
  は      助詞,係助詞,*,*,*,*,は,ハ,ワ
  ヌッコ  名詞,一般,*,*,*,*,*
  で      助動詞,*,*,*,特殊・ダ,連用形,だ,デ,デ
  ある    助動詞,*,*,*,五段・ラ行アル,基本形,ある,アル,アル
  。      記号,句点,*,*,*,*,。,。,。
  EOS
  ```

- Run CaboCha:

  ```sh
  $ docker compose run --rm python cabocha
  吾輩はヌッコである。
          吾輩は-D
    ヌッコである。
  EOS
  ```

- Run FastAPI:

  Run `uvicorn` server.

  ```sh
  $ docker compose up
  ```

  POST to http://127.0.0.1:8000/cabocha to run CaboCha (or http://127.0.0.1:8000/mecab for MeCab).

  ```python
  # run-api.py
  import requests

  params = {
      "text": "吾輩はヌッコである。",  # text to run Cabocha (or MeCab)
      "dictionary": "ipadic",  # Optional. 'ipadic' or 'neologd'
      "args": "-f 3",  # arguments for CaboCha (or MeCab).
  }

  response = requests.post(
      'http://127.0.0.1:8000/cabocha',  # or http://127.0.0.1:8000/mecab
      headers={"accept": "application/json"},
      params=params,
  )

  result = response.json()
  print(result.get('result'))
  ```

  ```sh
  $ python3 run-api.py
  <sentence>
   <chunk id="0" link="1" rel="D" score="0.000000" head="0" func="1">
    <tok id="0" feature="名詞,代名詞,一般,*,*,*,吾輩,ワガハイ,ワガハイ">吾輩</tok>
    <tok id="1" feature="助詞,係助詞,*,*,*,*,は,ハ,ワ">は</tok>
   </chunk>
   <chunk id="1" link="-1" rel="D" score="0.000000" head="2" func="4">
    <tok id="2" feature="名詞,一般,*,*,*,*,*">ヌッコ</tok>
    <tok id="3" feature="助動詞,*,*,*,特殊・ダ,連用形,だ,デ,デ">で</tok>
    <tok id="4" feature="助動詞,*,*,*,五段・ラ行アル,基本形,ある,アル,アル">ある</tok>
    <tok id="5" feature="記号,句点,*,*,*,*,。,。,。">。</tok>
   </chunk>
  </sentence>
  ```


## LICENSE

Apache-2.0

## Author(s)

[Tomoya Sawada](https://github.com/STomoya)
