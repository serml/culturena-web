FROM node:lts AS build
WORKDIR /app

# Instalar git para clonar dependencias
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install

# Copiar archivos del proyecto
COPY . .

# Clonar la librería de context-cursor en src/libs
RUN cd src/libs && \
    git clone https://github.com/PavelLaptev/context-cursor.git

# Construir el proyecto
RUN npm run build


FROM nginx:alpine AS runtime
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8109
