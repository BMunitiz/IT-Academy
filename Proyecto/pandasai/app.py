import streamlit as st
import pandas as pd
import pandasai as pai
from pandasai import SmartDataframe
from langchain_community.llms import Ollama
from langchain_groq.chat_models import ChatGroq
import os


#llm = Ollama(model = "gpt-oss:20b", temperature = 0)
llm = ChatGroq(model_name = 'llama-3.3-70b-versatile', temperature = 0.2, api_key= os.environ.get("GROQ_API_KEY"))

st.title("Data analyst powered by Pandas AI")

uploaded_file = st.file_uploader("Upload your file", type= "csv",)

if uploaded_file is not None:
    data = pd.read_csv(uploaded_file, low_memory= False)
    st.write(data.head(5))
    df = SmartDataframe(data, config={"llm": llm})
    prompt = st.text_area("Qué quieres saber?")
    if st.button("Generar"):
        if prompt:
            with st.spinner("Analizando"):
                response = df.chat(prompt)
                try: 
                    #response.endswith(".png")
                    st.image(response)
                except:
                    st.write(response)
        else:
            st.warning("Introduce tu consulta")



