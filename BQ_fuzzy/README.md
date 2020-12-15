# Fuzzy String matching using TF-IDF and Cosine Similarity
## A BigQuery approach

As outlined in the general algorithm in [implementation behind Python's string-grouper](https://bergvca.github.io/2017/10/14/super-fast-string-matching.html), this notebook contains the SQL Code implemented that can be used a rough implementation to begin with it.
The goal is to match company names that look similar to each other. Google Inc. and Google LLC etc.

Sometimes, due to the security or feasability constraints, we may have to solve problems in existing cloud services as opposed to some possibly better technologies.
Although this is primarily a NLP problem that would best fit with Spark, Dataflow or TensorFlow, I had a hunch about using BQ and went ahead with it.

A critical thing about BQ that made this possible was the ability to create user-defined scalar javascript functions in the code, to be used with SQL.

This opens up a huge world of possibilities and implementations, that the declarative style of SQL makes impossible to do. 

The general algo is misleadingly "simple".
1. Clean up the string (company_name) to keep only useful alphanumeric characters
2. Make trigrams out of this string, that will counted as words in a document.
3. Get the term frequency of each "word" in each "document".
4. Calculate it's relevance in the whole document corpus (all company names) by finding the inverse document frequency.
5. Get a tf-idf vector for each company name i.e. document.
6. Apply cosine similarity with one company's vectors across <b>ALL</b> the other vectors, and get most similar ones using a threshold (say 0.75 similarity)

As for how I did this with BQ, w.r.t to steps mentioned above and the code shared : 

1. Steps 1,2,3 were acheived in one query `MakeNgrams.sql`. Simple regex to clean a word, and JS function to make trigrams with term frequency respective to each word.
2. Step 4 was acheived with one query, which had nested subqueries. `process_tfidf.sql`
At this point, we basically had the tf-idf vectors for each word in the dataset. These steps took surprisingly less time. (<6-7min for under a million)
3. This is the hard part. Since we are working with SQL, an intuitive way of looking at this is a cross-join, calculate cosine similarity, and count with threshold.
  * Slight caveat, JS functions take a little time as it involves starting a subprocess at each worker to execute.
  * So ideally, we want to limit how many times we call that function. 
  * This involved some hacking. Since I want to match company names fuzzily, I realised that my matches would usually have the same length more or less, and only change a few characters in the word. So I should make my candidates for each word a list of vectors of words with length just 1 greater or lesser, or equal.  
4. Now, we will run a cross join on every single element and aggregate the vectors that match the length condition. On top of this result, now we can run cosine similarity.
Although this could be done in some nested subqueries - the BQ engine was resolving conditions in a different way. So I couldn't force the cosine similarity to happen <i>AFTER</i> the length checking.
5. So I aggregated and unnested the cross join results into one MEGA table, that had the name, source tf-idf vector, and target tf-idf vector. This was done in the `make_candidates_pre_cosine.sql` 
6. I could now run a simple query to calculate the cosine similarity with another JS function, and count based on the ones that met my threshold. This query is `final_get_similarity.sql`

Much to my dismay, this query was working on an interim table that was billions of rows (possible candidates) long, and it took upwards of an hour. While this may yield results, I deemed it inefficient off the bat and chose not to proceed further.

Lessons learnt:

1. Avoid cross joins. Self-explanatory. 
2. Serilization and data representation is key. Since I was working out of the constraints of BQ, I was using Strings to represent my vectors. This isn't ideal.
3. Build use-case specific optimizations. Depending on what exactly we want, we can add optimizations whereever we can think of for e.g. the length based selection.  

Mid-way solution:
Since the tf-idf computation wasn't a problem wrt execution time, if we have huge list that we want to work on in BQ, we can vectorize using Steps 1 and 2 above very easily.

While we may not want to get fuzzy groups of every single data-point - we may have a situation wherein we want to find out the matches for a specific data-point or two. 

This is a classic situation for a SQL query, and the query in `final_get_similarity.sql` can be easily repurposed to do so to get this, as demonstrated in `revolving_cosine_sim.sql`.
This approach benefits from the speed of BQ, and can even be used in near real-time i.e. linking it with a web-app for example. 

Conclusion:
I still have some hopes pinned on this method - and I believe with some more work and insights (and a fresh pair of eyes) - it can be a reasonable solution.
Thanks for reaching here! Hope you enjoyed this.

P.S. This is a true-blue SparkML problem , and will now redirect my efforts in that direction. 
