#!/usr/bin/env bash
#
# @author mb
# @title UniProt Solyc id converter
# @description 
# bash program that convert UniProt -> ID Solyc and Polypeptide description
#

FILE_CODIGOS=codes.txt
RESULT=$(date +%H%M%S)_result.txt

URL_UNIPROT="https://www.uniprot.org/uniprot"
URL_SOLGEN="https://solgenomics.net"
URL_PHYTOZOME="https://phytozome.jgi.doe.gov/pz/phytoweb/keywordsearch"

# curl default params
CURL_DEFAULT_PARAMS="--connect-timeout 5 "
CURL_DEFAULT_PARAMS+="--max-time 10 " # how long each retry will wait
CURL_DEFAULT_PARAMS+="--retry 5 " 
CURL_DEFAULT_PARAMS+="--retry-delay 0 " # an exponential backoff algorithm
CURL_DEFAULT_PARAMS+="--retry-max-time 60 " # total time before it's considered failed

searchDescGen() {
  local url=$(findUrlDescGen $1)  
  local res=$(curl -s $CURL_PARAMS $url | grep -C5 --color "class=\"sequence.*" | tr -d '\n' | sed 's/<form/\n/g' | grep -o "Solyc.*" | head -1)
  echo "$res"
}

searchDescGenInPhytozome() {
  local code="$1"
  local curl_result=$(curl -s $CURL_PARAMS $URL_PHYTOZOME \
  -H 'Cookie: _ga=GA1.2.1209249071.1531160322; __utmz=89664858.1541421123.8.5.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utma=89664858.1209249071.1531160322.1541423686.1543671668.10; __utmc=89664858; __utmt=1; __utmb=89664858.16.10.1543671668' \
  -H 'Origin: https://phytozome.jgi.doe.gov' \
  -H 'Accept-Encoding: gzip, deflate, br' \
  -H 'Accept-Language: es-ES,es;q=0.9' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36' \
  -H 'Content-Type: text/x-gwt-rpc; charset=UTF-8' \
  -H 'Accept: */*' \
  -H 'X-GWT-Module-Base: https://phytozome.jgi.doe.gov/pz/phytoweb/' \
  -H 'X-GWT-Permutation: E55079081038A840A67B6E4B8531A61A' \
  -H 'Referer: https://phytozome.jgi.doe.gov/pz/portal.html' \
  -H 'Connection: keep-alive' \
  --data-binary '7|0|10|https://phytozome.jgi.doe.gov/pz/phytoweb/|586D31F87ED8E95E9B7E23B85764FF3C|org.jgi.phyto.client.service.KWSService|fetch|org.jgi.phyto.shared.CQuery/2500317377|1|5087|0|1111111111111111111111111111111111111111111111111111111111111111|'$code'|1|2|3|4|1|5|5|6|0|0|0|0|0|0|0|0|7|8|0|0|9|0|0|8|10|0|6|0|' \
  --compressed)
  
  local desc_gen=$(echo "$curl_result" | sed 's/"\",\""/\\n/g' | sed 's/","/\n/g' | grep --color "$code.*")
  
  echo "$desc_gen"
}

findUrlDescGen() {
  local res=$(curl -s $CURL_PARAMS "$URL_SOLGEN/ajax/search/features?organism=1&type_id=22027&name=$1" | grep -o "feature.*details")
  echo "$URL_SOLGEN/$res"
}

main() {
  echo "Starting..."
  echo "code count: " $(wc -l $FILE_CODIGOS)  
  for line in $(cat $FILE_CODIGOS)
  do
    url_search="$URL_UNIPROT/$line"
    id_gen=$(curl -s -k $CURL_PARAMS "$url_search" | tr ' ' '\n' | tr '>' '>\n' | grep -o --color "Solyc[0-9][0-9]g.*\"" | tr -d '"' | head -1)
    
    echo $cod"#"$id_gen
    echo $cod"#"$id_gen"#""$(searchDescGenInPhytozome $id_gen)" >> $RESULT
  
  done
  echo "[DONE]"
}

main

