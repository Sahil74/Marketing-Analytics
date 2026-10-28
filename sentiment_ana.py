import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from database import get_connection
#nltk.download('vader_lexicon')
conn = get_connection()

def fetch_data(query):
    try:
        with conn:
            df = pd.read_sql(query, conn)
    finally:
        conn.close()
    return df

Query = """ SELECT "ReviewID", "CustomerID", "ProductID", "ReviewDate", "Rating", REPLACE("ReviewText", '  ', ' ') AS "ReviewText" FROM customer_reviews; """
customer_reviews_df = fetch_data(Query)


senti = SentimentIntensityAnalyzer()

def calculate_senti(review):
    sentiment = senti.polarity_scores(review)
    return sentiment['compound']

def categories(score,rating):
    if score > 0.05:
        if rating >= 4:
            return "Positive"
        elif rating == 3:
            return "Mixed Positive"
        else:
            return "Mixed negative"
    elif score < -0.05: 
        if rating >= 4:
            return "Negative"
        elif rating == 2:
            return "Mixed Negative"
        else:
            return "Mixed Positive"
    else:
        if rating >= 4:
            return "Positive"
        elif rating == 2:
            return "Negative"
        else:
            return "Neutral"

def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0'  
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'  
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0'  
    else:
        return '-1.0 to -0.5'  


customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_senti)
customer_reviews_df['SentimentCategory'] = customer_reviews_df.apply(
    lambda row: categories(row['SentimentScore'], row['Rating']), axis=1)

# Apply sentiment bucketing to categorize scores into defined ranges
customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)

# Display the first few rows of the DataFrame with sentiment scores, categories, and buckets
print(customer_reviews_df.head())

# Save the DataFrame with sentiment scores, categories, and buckets to a new CSV file
customer_reviews_df.to_csv('fact_customer_reviews_with_sentiment.csv', index=False)
