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

Query = """select * from calendar;""" # Calendar, Customers, Customer_journey, Customer_reviews, products, Eng_data
customer_reviews_df = fetch_data(Query)
customer_reviews_df.to_csv('calendar.csv', index=False)