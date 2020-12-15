create temp function similarity(word1 string, word2 string) 
RETURNS FLOAT64
LANGUAGE js AS """
var matrix1 = new Map()
var matrix2 = new Map()
var allNgrams = new Set()
for( ngram of word1.split(",")){
  matrix1.set(ngram.split(":")[0], parseFloat(ngram.split(":")[1]))
  allNgrams.add(ngram.split(":")[0])
}
for( ngram of word2.split(",")){
  matrix2.set(ngram.split(":")[0], parseFloat(ngram.split(":")[1]))
  allNgrams.add(ngram.split(":")[0])
}
var vector1 = []
var vector2 = []
for (let ngram of allNgrams) {
  vector1.push(matrix1.has(ngram) ? matrix1.get(ngram) : 0.0)
  vector2.push(matrix2.has(ngram) ? matrix2.get(ngram) : 0.0)
}
var dotproduct=0;
var mA=0;
var mB=0;
for(i = 0; i < vector1.length; i++){
        dotproduct += (vector1[i] * vector2[i]);
        mA += (vector1[i]*vector1[i]);
        mB += (vector2[i]*vector2[i]);
}
mA = Math.sqrt(mA);
mB = Math.sqrt(mB);
return (dotproduct)/((mA)*(mB))
""";

select company_name,  count(*) as counts from (
select company_name, similarity(a_tfidf, b_tfidf) as similarity from `cs686-hrishmoola.bq_nlp_playground.interim_pre_cosine`) where similarity > 0.70 group by 1
