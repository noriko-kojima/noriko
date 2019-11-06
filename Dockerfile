#ベースをubuntuにする
#FROM イメージ名：タグ
#FROM ubuntu:16.04
FROM nvidia/cuda:9.0-devel-ubuntu16.04

#RUN echo "Hello,World!"
#これはできた

# Minicondaのインストール法(できた！)
## apt-getをupdate
RUN apt-get update -y && apt-get upgrade -y

## minicondaのpackageをinstall
RUN apt-get install -y wget curl bzip2 libpython3-dev libboost-python-dev

## anacondaをinstall
RUN curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

## アクセス権限の変更
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh

## anacondaをinstall
RUN bash Miniconda3-latest-Linux-x86_64.sh -b

## インストーラを削除
RUN rm Miniconda3-latest-Linux-x86_64.sh

## PATHを通す
ENV PATH $PATH:/root/miniconda3/bin

## python2系をinstall (conda info -e で確認)
RUN conda create -n py27 python=2.7 anaconda

## numpy , pandas , jupyter , scikit-learn , keras , opencv , matplotlib , tensorflow-gpu を install
RUN conda install numpy pandas jupyter scikit-learn keras opencv matplotlib tensorflow-gpu
