# Hướng dẫn cài đặt và chạy hệ thống Đồ Án Tốt Nghiệp

## 🧩 Yêu cầu hệ thống

- Docker và Docker Compose đã được cài đặt sẵn.
- Hệ điều hành: Ubuntu (hoặc WSL Ubuntu trên Windows)

## 🛠️ Các bước cài đặt và chạy

1. **Clone dự án về máy**
   ```bash
   git clone https://github.com/TinDuong9503/do-an-tot-nghiep.git
   cd do-an-tot-nghiep
2. **Thêm quyền cho script chờ service khởi động**

    ```bash 
    chmod +x wait-for.sh 
3. ** Khởi chạy toàn bộ hệ thống bằng Docker Compose ** 
```bash 
docker-compose up -d --build