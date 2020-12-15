create temp function makengrams2(word string) 
RETURNS ARRAY<STRING>
LANGUAGE js AS """
var ngramsArray = [];
    let map = new Map()
    for (var i = 0; i < word.length - 2; i++) {
        var ngram = "";
        for (var j = 0; j < 3; j++) {
            ngram = ngram.concat(word[i + j])
        }
        ngramsArray.push(ngram);
        if(!map.has(ngram)){
          map.set(ngram, 0)
        }
        map.set(ngram, map.get(ngram) + 1)
    }
    tfMap = new Map()
    for (let [key, value] of map.entries()) {
      tfMap.set(key, (value/ngramsArray.length).toFixed(3))
    }
    var finalArray = []
    for(entry in ngramsArray){
      finalArray.push(ngramsArray[entry] + ":" + tfMap.get(ngramsArray[entry]))
    }
    
    return finalArray
""";

SELECT Company_Name, Company_Name_Cleaned, (makengrams2(Company_Name_Cleaned)) as ngrams FROM (select distinct(REGEXP_REPLACE(Company_Name, "[^a-zA-Z0-9]", "")) as Company_Name_Cleaned , Company_Name from `cs686-hrishmoola.bq_nlp_playground.company_data`)

-- https://bergvca.github.io/2017/10/14/super-fast-string-matching.html
