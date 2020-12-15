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

select * from (
select company_name_cleaned, similarity("NAS:0.056376 , ER2:0.060432 , NGH:0.062064 , EVO:0.065976 , QUT:0.094872 , BAC:0.056639999999999996 , ASS:0.036528 , GHO:0.066864 , ACK:0.046248000000000004 , YLO:0.06192 , MEE:0.065064 , CKC:0.066408 , OME:0.040824 , LVI:0.06552 , SET:0.043488 , LOA:0.053808 , TYL:0.054744000000000008 , SSE:0.036264 , ERT:0.034032 , TSE:0.042096 , VOL:0.067416 , R20:0.062400000000000004 , RTS:0.050616 , OLV:0.078984 , UTY:0.08832000000000001 , TBA:0.059208000000000004 , 00B:0.09696 , HOM:0.043656 , 200:0.041208 , EQU:0.042192 , 000:0.06948 , SER:0.029904 , REV:0.061391999999999995 , EEQ:0.056063999999999996 , ANA:0.036455999999999995 , CER:0.05088 , VIN:0.048047999999999993 , OAN:0.052775999999999997 , ING:0.026112000000000003 , ETB:0.06468 , KCE:0.08256", f0_) as similarity from `cs686-hrishmoola.bq_nlp_playground.revolving_tf_idfs` )
where similarity > 0.40 order by similarity desc
