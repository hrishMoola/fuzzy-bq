select company_name_cleaned, STRING_AGG(TFIDF,' , ') from(
SELECT  *, CONCAT(NGRAM_ONLY, ":", CAST(CAST(TF AS FLOAT64) * IDF as STRING)) as tfidf FROM `cs686-hrishmoola.bq_nlp_playground.processed_tf_idf`) group by 1
