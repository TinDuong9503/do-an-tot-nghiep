FROM eclipse-temurin:22-jdk

# Cài netcat để dùng trong wait-for.sh
RUN apt-get update && apt-get install -y netcat-openbsd


WORKDIR /app

# Copy file .jar vào image
COPY target/SaveBlood-0.0.1-SNAPSHOT.jar app.jar

COPY wait-for.sh wait-for.sh
RUN chmod +x wait-for.sh

EXPOSE 8080

# Chạy wait-for.sh và sau đó chạy ứng dụng
ENTRYPOINT ["./wait-for.sh", "mysql", "3306", "java", "-jar", "app.jar"]

