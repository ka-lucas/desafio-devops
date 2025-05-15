# Use uma imagem base oficial do Python
FROM python:3.10-slim

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o arquivo de dependências (requirements.txt ou poetry.lock) para o diretório de trabalho
COPY pyproject.toml poetry.lock ./

# Instale o Poetry e as dependências
# Instala Poetry e dependências sem ambiente virtual
RUN pip install poetry \
    && poetry config virtualenvs.create false \
    && poetry install --only main
# Copie o restante dos arquivos da aplicação para dentro do container
COPY . .

# Defina as variáveis de ambiente necessárias (se houver)
ENV PYTHONUNBUFFERED=1
ENV NAME="World"

# Exponha a porta que o aplicativo irá utilizar
EXPOSE 8080

# Defina o comando para rodar a aplicação
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "wsgi:app"]
