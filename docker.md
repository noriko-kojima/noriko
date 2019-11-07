# Docker構築

## 目的
- 実務に必要な環境構築の知識を得る
- dockerの使い方に慣れる

## Dockerについて調査
1. Dockerとは  
    - 仮想化技術(VM Wareの進化版？)
    - Docker と 仮想マシンとの違い  
    Docker  
        - Linuxのコンテナ技術を用いた
        - ゲストOSを立てずに、ホストOSの上でコンテナを作り、その上でミドルウェアを動かす
        - 利点：1つのOS(ホストOS)を複数のサーバ(コンテナ)が利用している→軽量で高速に起動/停止ができる  
            - 複数の国があるイメージ(1つ1つを統制するのに時間がかかる)

        仮想マシン(VM Ware etc...)      
        - ホストOSの上に、サーバ(仮想マシン)ごとに、ゲストOSを立てて、その上でミドルウェアを動かす
            - 1つの国に複数の町があるイメージ(リーダーが言えば、すぐに統制が取れる)
 - 参考サイト
    - https://knowledge.sakura.ad.jp/13265
    - https://udemy.benesse.co.jp/development/web/docker.html
    -  Dockerインストール  
https://qiita.com/takeru08ma/items/849a861d8bb93c71bb


1. Docker用語
    - docker image  
        - コンテナを作るためのひな型。どのOSにどんなアプリを搭載してどんな動作をするかの情報が入っている。これを作れば、同じ内容のコンテナを量産できる。

    - コンテナ
        - Dockerイメージを生成するとできる。実行中、停止、破棄の３つの状態がある。

    - nvidia-docker
        - Docker コンテナ内から CUDA を扱えるようにする仕組み
    - dockerfile  
        - コンテナを作るときの説明書および手順書
        - シェルスクリプトみたいな？

    - Docker Hub
        - web上で公開されているdockerイメージ。すでにイメージがあるので、そこから取ってくれば、Dockerコンテナを起動できて、すぐに使用可能。便利！
            ![dockerhubで「ubuntu:16.04」で検索](2019-10-23-15-28-23.png)

    - Docker Compose
        - 複数のコンテナで構成されるアプリケーションについて、Dockerイメージのビルドや各コンテナの起動・停止などをより簡単に行えるようにするツール
        - 複数のコンテナの定義をymlファイルに書き、それを利用してDockerビルドやコンテナを起動することができる。1つのコマンドで複数のコンテナを管理できる。  

## 作業内容
1. Docker作業の流れ
    1. Dockerfileに記述
    2. ビルドしてDockerイメージを作成
    3. 実行してコンテナ生成  


1. 盛り込む機能一覧  
    1. [Ubuntu16.04](https://qiita.com/pochy9n/items/69ab8fc071c187a1f5f8)
    - ベースとなる実行環境   

        - 確認方法：cat /etc/os-release
    でubuntuがどのバージョンかが分かる。 
    2. [nvidia-cuda9.0](https://www.kagoya.jp/howto/rentalserver/gpu_deeplearning_ai/)
        - NVIDIA社のCUDA
        - [GPU](https://www.kagoya.jp/howto/rentalserver/gpu1/)(Graphics Processing Unit：描写するための計算機能を持っている)が絵を描くために培ってきた計算能力を、汎用的な用途に拡張するためのプログラムを書くのに使う、エンジニア向けの枠組み  
          
        ※ CPUとGPUの違い(どちらも計算処理を行う機能)  
        - CPU：PCやサーバ(PC全体)にあたる計算をする  
        - GPU：画像専門の計算をする
    - cudaのバージョン確認方法
        - 「nvcc -V」で確認(http://tecsingularity.com/cuda/version_conf/)
        - 参考サイト：https://qiita.com/namahoge/items/542ba95fd3892b57d6fb


    3. [cudnn7](https://fun-mylife.com/install-gpu-deep-learning)
        - NVIDIAが公開しているDeep Learning用のライブラリ。  
        - DNNで使われる基本的な機能をまとめたCUDAライブラリ。  
        - 参考サイト：
        https://news.mynavi.jp/article/20150410-gtc2015_cudnn/  
        https://fun-mylife.com/install-gpu-deep-learning)

    4. [miniconda](https://github.com/yorek/docker-anaconda/blob/master/Dockerfile.ubuntu.miniconda)(Python2系,Python3系が使えるように)
        - Anacondaを最小パッケージ構成に限定したディストリビューション 
        - 異なるバージョンのpythonをインストールする方法：
conda create -n py27 python=2.7 anaconda
「conda info -e」 で確認
https://qiita.com/t2y/items/2a3eb58103e85d8064b6

    5. numpy
    6. pandas
    7. jupyter
    8. scikit-learn
    9. keras
    10. opencv
    11. matplotlib
    12. tensorflow-gpu
        - 5～12は並列してinstallできる↓
https://casualdevelopers.com/tech-tips/Ohow-to-setup-anaconda-and-tensorflow-with-docker/
## 起こったエラー＆その対処法
- 原因：「FROM ubuntu:16.04」と書くと、dockerhubのubuntu16.04から取ってきてくれるため、そのようなパッケージはないと言われる？

- 解決法：ベースとなる環境をubuntu16.04に設定する(FROM ubuntu:16.04とDockerfileに記載することで解消した)
    ![ubuntu16.04のエラー画面](2019-10-23-13-33-56.png)

- miniconda以降はpython環境上でないと動かない。apt-getしても動かない。(E:Unable to locate package numpyというエラーが出る)

- PATH PATH /root/miniconda3/bin:\$PATH(
    →Dockerfile用のやつか？
    →普通、PATHを通すのはこっち↓
    →export PATH=/root/miniconda3/bin:$PATH

## その他
### 環境変数の設定方法
https://qiita.com/fuwamaki/items/3d8af42cf7abee760a81

echo $PATH
ls /root/miniconda3/binで「conda」コマンドがあることを確認

export PATH=/root/miniconda3/bin:$PATH
→condaを使えるようになった

##  Docker基礎コマンド
- docker run  
    Dockerイメージを使用して、コンテナを起動させる

- docker rm [イメージID]  
イメージID：docker ps -a(現在停止しているコンテナを確認)の「CONTAINER　ID」 
cf.https://qiita.com/tifa2chan/items/e9aa408244687a63a0ae

- docker build -t 作成イメージ名 Dockerfile格納フォルダ名
    - docker build -t sample .
→sampleという名前のイメージが作られる。
https://qiita.com/fkooo/items/53b2ea865e8c2c7fec27

- docker pull ubuntu:16.04
    - イメージのダウンロード
https://qiita.com/kouma1990/items/9b2c56b379ff58d67090
