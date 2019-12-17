FROM debian
RUN apt update
RUN apt install wget gnupg2 sudo make build-essential -y
RUN apt install libncurses-dev git autoconf -y
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
RUN dpkg -i Erlang-solutions_2.0_all.deb
RUN apt-get update
RUN apt-get install esl-Erlang -y
RUN apt-get install elixir -y
RUN git clone https://github.com/Erlang/otp
WORKDIR otp
RUN git checkout maint
RUN git checkout 6901bf27ade015c3bb6ff5766d7f71fbec90dd8f
ADD patch .
RUN ./otp_build autoconf
RUN ./configure
RUN make
RUN make install
ADD appone /opt/app
WORKDIR /opt/app
RUN mix compile
CMD mix run --no-halt