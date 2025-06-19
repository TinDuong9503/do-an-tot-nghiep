import axios from "axios";
import axiosInstance from "../axiosConfig";


class UserService{
    static BASE_URL = "http://localhost:8080"

    static async login(loginDetails){
        try{
            const response = await axiosInstance.post(`/auth/login`, loginDetails)
            return response.data;

        }catch(err){
            throw err;
        }
    }
   
    static async register(userData, token) {
        try {
            // Conditionally set headers if token is provided
            const headers = token ? { Authorization: `Bearer ${token}` } : {};
    
            // Send the POST request to register the user
            const response = await axiosInstance.post(`/auth/register`, userData, { headers });
            return response.data;  // Return the response data (e.g., success message or user data)
        } catch (err) {
            // Enhanced error handling
            if (err.response) {
                // The server responded with an error
                if (err.response.status === 400) {
                    // For example, handle validation errors or bad request
                    throw new Error(`Registration failed: ${err.response.data.message || "Invalid input data."}`);
                } else if (err.response.status === 500) {
                    // Internal server error
                    throw new Error("Server error. Please try again later.");
                } else if (err.response.status === 409) {
                  throw new Error('Người dùng đã tồn tại')
                }
                throw new Error(`Error: ${err.response.data.message || "An error occurred during registration."}`);
            } else if (err.request) {
                // No response from the server
                throw new Error("Network error: No response from server.");
            } else {
                // Other errors
                throw new Error(`Error: ${err.message}`);
            }
        }
    }

    //Get All
    static async getAllUsers(token){
        try{
            const response = await axiosInstance.get(`/admin/get-all-users`, 
            {
                headers: {Authorization: `Bearer ${token}`}
            })
            return response.data;
        }catch(err){
            throw err;
        }
    }

    //Get Profile 
    static async getYourProfile(token) {
      try {
          if (!token) {
              throw new Error("Token is missing.");
          }
  
          console.log("Using token:", token);
  
          const response = await axiosInstance.get(`/adminuser/get-profile`, {
              headers: {
                  Authorization: `Bearer ${token}`,
                  "Content-Type": "application/json",
              },
          });
  
          return response.data;
      } catch (err) {
          console.error("Error fetching profile:", err.message);
          if (err.response) {
              console.error("Server response:", err.response.data);
          }
          throw new Error("Không thể lấy thông tin hồ sơ.");
      }
  }
  
    //Delete USER
    static async deleteUser(cccd, token){
        try{
            const response = await axiosInstance.delete(`/admin/delete/${cccd}`, 
            {
                headers: {Authorization: `Bearer ${token}`}
            })
            return response.data;
        }catch(err){
            throw err;
        }
    }

   static async updateOwnUserProfile(token, cccd, userData) {
    try {
        const response = await axiosInstance.put(
            `/update-own-profile/${cccd}`,
            userData,
            {
                headers: {
                    Authorization: `Bearer ${token}`,
                    'Content-Type': 'application/json',
                },
            }
        );
        return response.data;
    } catch (error) {
        console.error("Error updating user profile:", error);
        throw error;
    }
}

    //Update User
    static async updateUser(username, userData, token) {
        try {
          // Transform roles to send as a single value instead of an array
          const transformedData = {
            ...userData,
            roles: userData.roles.length > 0 ? userData.roles[0] : null,
          };
    
          const response = await axiosInstance.put(`/admin/update/${username}`, transformedData, {
            headers: {
              Authorization: `Bearer ${token}`,
              'Content-Type': 'application/json',
            },
          });
          return response.data;
        } catch (error) {
          throw error;
        }
      }

    static async getUserById(username) {
      try {
      
          const response = await axiosInstance.get(`/admin/get-users/${username}`, {
              headers: {
                  "Content-Type": "application/json",
              },
          });
  
          return response.data;
      } catch (err) {
          console.error("Error fetching profile:", err.message);
          if (err.response) {
              console.error("Server response:", err.response.data);
          }
          throw new Error("Không thể lấy thông tin hồ sơ.");
      }
    }

    /**AUTHENTICATION CHECKER */
    static logout(){
        localStorage.removeItem('token')
        localStorage.removeItem('role')
    }

    static isAuthenticated(){
        const token = localStorage.getItem('token')
        return !!token
    }

    static isAdmin(){
        const role = localStorage.getItem('role')
        console.log("role ", role)
        return role === "ADMIN"
    }

    static isUser(){
        const role = localStorage.getItem('role')
        return role === 'USER'
    }

    static adminOnly(){
        return this.isAuthenticated() && this.isAdmin();
    }



    //Password
    static async requestPasswordReset(email) {
        try {
          const response = await axiosInstance.post("/auth/reset-password-request", {
            email,  // Gửi email trong body của yêu cầu POST
          });
    
          // Kiểm tra mã trạng thái HTTP (200 OK)
          if (response.status === 200) {
            return response.data; // Trả về dữ liệu từ phản hồi (có thể là thông báo thành công hoặc dữ liệu liên quan)
          } else {
            throw new Error("Failed to request password reset");
          }
        } catch (error) {
          // Xử lý lỗi nếu có
          console.error(error);
          throw error; // Ném lại lỗi để có thể xử lý ở nơi khác
        }
      }
    
      static async resetPassword(token, newPassword) {
        try{
            const response = await axiosInstance.put("/auth/reset-password", {
                newPassword,
                token
              });
        
              if (response.status === 200) {
                return response.data; // Trả về dữ liệu từ phản hồi (có thể là thông báo thành công hoặc dữ liệu liên quan)
              } else {
                throw new Error("Failed to request password reset");
              }
        }catch(error){
            console.log(error);
            throw error;
        }
       
      }


     /**UNIT */


    // Unit Donation 
      static async addUnit(formData) {
        const result = await axiosInstance.post("/units/add", formData, {
            headers: {
                ...this.getHeader(),
                'Content-Type': 'multipart/form-data'
            }
        });

        if (result.status === 200) {
            return result.data; // Trả về dữ liệu từ phản hồi (có thể là thông báo thành công hoặc dữ liệu liên quan)
          } else {
            throw new Error("Failed to request password reset");
          }
    }


    //Get By ID
    static async getDonationUnitById(id, token) {
        try {
            const result = await axiosInstance.get(`/units/get-unit/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`,
                }
            });
            console.log("API Response:", result);  // Xem kết quả trả về từ API
            return result.data;  // Lấy dữ liệu từ kết quả
        } catch (err) {
            console.error("Error fetching unit data:", err);
            throw err;
        } 
    }
    
    //get All Unit

    static async getAllUnits(token){
        try{
            const response = await axiosInstance.get(`/units/get-all`, 
            {
                headers: {Authorization: `Bearer ${token}`}
            })
            return response.data;
        }catch(err){
            throw err;
        }
    }
    static async deleteUnit(id, token) {
        try {
            const response = await axiosInstance.delete(`/units/delete/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}` // Truyền token vào headers nếu cần
                }
            });
            return response.data; // Trả về dữ liệu từ API nếu cần sử dụng sau này
        } catch (err) {
            throw err; // Ném lỗi để xử lý ở nơi gọi hàm
        }
    }


    // update unit
    static async updateUnit(id, unitData, token) {
        const formData = new FormData();
        
        // Thêm các thông tin dữ liệu vào FormData
        formData.append("data", JSON.stringify({
        name: unitData.unit,
        location: unitData.location,
        email: unitData.email,
        phone: unitData.phone,
        }));
    
        // Nếu có ảnh mới, thêm ảnh vào FormData
        if (unitData.photo) {
        formData.append("photo", unitData.photo);
        }
    
        try {
        const result = await axiosInstance.put(`/units/update/${id}`, formData, {
            headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "multipart/form-data",  // Đảm bảo header này được thiết lập
            },
        });
        console.log("asd",result.data);
        return result.data;
        } catch (error) {
        console.error("Error updating unit:", error);
        throw error;  // Bạn có thể ném lỗi ra ngoài để có thể xử lý ở nơi gọi API
        }
    }
  




    //************EVENT

    //add Event
   static async addEvent(eventData, token) {
  try {
    const response = await axiosInstance.post('/events/add', eventData, {
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json' // Quan trọng: chỉ định JSON
      }
    });
    return response.data;
  } catch (err) {
    throw err;
  }
}

    //Get All EventEvent
    static async getAllEvents(token){
        try{
            const response = await axiosInstance.get(`/events/get-all`, 
            {
                headers: {Authorization: `Bearer ${token}`}
            })
            return response.data;
        }catch(err){
            throw err;
        }
    }

    //Delete EventEvent
    static async deleteEvent(id, token) {
        try {
            const response = await axiosInstance.delete(`/events/delete/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}` // Truyền token vào headers nếu cần
                }
            });
            return response.data; // Trả về dữ liệu từ API nếu cần sử dụng sau này
        } catch (err) {
            throw err; // Ném lỗi để xử lý ở nơi gọi hàm
        }
    }

        //Get Event IDID
    static async getEventById(id, token) {
        try {
            const result = await axiosInstance.get(`/events/get/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`,
                }
            });
            console.log("API Response:", result);  // Xem kết quả trả về từ API
            return result.data;  // Lấy dữ liệu từ kết quả
        } catch (err) {
            console.error("Error fetching unit data:", err);
            throw err;
        }
    }

    static async getEventsByUnit(token, unitId) {
      try {
          // Kiểm tra token
          if (!token) {
              throw new Error("Token is required.");
          }
  
          // Gửi yêu cầu tới API backend
          const response = await axiosInstance.get(`/events/by-unit`, {
              params: {
                unitId: unitId || ""
              },
              headers: {
                  Authorization: `Bearer ${token}`,
                  "Content-Type": "application/json",
              },
          });
  
          console.log("Data fetched:", response?.data?.eventDTOList);
          return response?.data?.eventDTOList || []; // Đảm bảo trả về mảng rỗng nếu không có dữ liệu
      } catch (err) {
          // Xử lý lỗi và thông báo chi tiết
          console.error("Error fetching events by date range:", err.message);
          if (err.response && err.response.data) {
              console.error("Server response:", err.response.data);
          }
          throw new Error("Không thể tải danh sách sự kiện. Vui lòng thử lại sau.");
      }
  }
    //Get BetweenDate
    static async getEventsByDateRange(token, startDate, endDate) {
        try {
            // Kiểm tra token
            if (!token) {
                throw new Error("Token is required.");
            }
    
            // Gửi yêu cầu tới API backend
            const response = await axiosInstance.get(`/events/by-date-range`, {
                params: {
                    startDate: startDate || "", // Chuỗi rỗng nếu không có startDate
                    endDate: endDate || "",     // Chuỗi rỗng nếu không có endDate
                       // Null nếu không có unitId
                },
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json",
                },
            });
    
            console.log("Data fetched:", response?.data?.eventDTOList);
            return response?.data?.eventDTOList || []; // Đảm bảo trả về mảng rỗng nếu không có dữ liệu
        } catch (err) {
            // Xử lý lỗi và thông báo chi tiết
            console.error("Error fetching events by date range:", err.message);
            if (err.response && err.response.data) {
                console.error("Server response:", err.response.data);
            }
            throw new Error("Không thể tải danh sách sự kiện. Vui lòng thử lại sau.");
        }
    }
    
    

        //Get Event By Date
        static async getEventByDate(id, token) {
            try {
                const result = await axiosInstance.get(`/events/get-by-date/${id}`, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    }
                });
                console.log("API Response:", result);  // Xem kết quả trả về từ API
                return result.data;  // Lấy dữ liệu từ kết quả
            } catch (err) {
                console.error("Error fetching unit data:", err);
                throw err;
            }
        }


    //Update Eventnt
            static async updateEvent(id, eventData, token) {
            try {
                const response = await axiosInstance.put(`/events/update/${id}`, eventData, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    }
                });
                return response.data;
            } catch (error) {
                console.error("Error updating event:", error);
                throw error;
            }
        }



      //NEws Service
      static async getAllNewsForUser() {
        try {
          const response = await axiosInstance.get('/news')
    
          // Log dữ liệu trả về để kiểm tra cấu trúc của nó
          console.log("Dữ liệu API trả về:", response.data);
    
          // Kiểm tra nếu dữ liệu có trường newsDTO
          if (response.data && response.data.newsDTOList) {
            return response.data; // Trả về toàn bộ dữ liệu từ API
          } else {
            console.error("Dữ liệu không có trường newsDTO");
            return {}; // Trả về object rỗng nếu dữ liệu không đúng
          }
        } catch (err) {
          console.error("Lỗi khi gọi API getAllNews:", err.message);
          throw err;
        }
      }


      //Get All NewsNews
      static async getAllNews() {
        try {
          const response = await axiosInstance.get('/news');
         
    
          // Log dữ liệu trả về để kiểm tra cấu trúc của nó
          console.log("Dữ liệu API trả về:", response.data);
    
          // Kiểm tra nếu dữ liệu có trường newsDTO
          if (response.data && response.data.newsDTOList) {
            return response.data; // Trả về toàn bộ dữ liệu từ API
          } else {
            console.error("Dữ liệu không có trường newsDTO");
            return {}; // Trả về object rỗng nếu dữ liệu không đúng
          }
        } catch (err) {
          console.error("Lỗi khi gọi API getAllNews:", err.message);
          throw err;
        }
      }
      //deleteNews
      static async deleteNews(id, token) {
        try {
            const response = await axiosInstance.delete(`/news/delete/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}` // Truyền token vào headers nếu cần
                }
            });
            return response.data; // Trả về dữ liệu từ API nếu cần sử dụng sau này
        } catch (err) {
            throw err; // Ném lỗi để xử lý ở nơi gọi hàm
        }
    }
      


      //Appointment

      //Save appointment
      //Get All AppointmentsAppointments
      static async getAllAppointments(token) {
        try {
          const response = await axiosInstance.get('/appointments', {
            headers: { Authorization: `Bearer ${token}` }
          });
    
          // Log dữ liệu trả về để kiểm tra cấu trúc của nó
          console.log("Dữ liệu API trả về:", response.data);
          
          // Kiểm tra nếu dữ liệu có trường newsDTO
          if (response.data ) {
            return response.data; // Trả về toàn bộ dữ liệu từ API
          } else {
            console.error("Dữ liệu không có trường newsDTO");
            return {}; // Trả về object rỗng nếu dữ liệu không đúng
          }
        } catch (err) {
          console.error("Lỗi khi gọi API getAllNews:", err.message);
          throw err;
        }
      }


      static async saveAppointment(token,username, eventId,healthMetrics){
        try {
            // Kiểm tra token
            if (!token) {
                throw new Error("Token is required.");
            }
            const formattedData = {
              healthMetrics: {
                  hasDonatedBefore: healthMetrics.hasDonatedBefore,
                  hasChronicDiseases: healthMetrics.hasChronicDiseases,
                  hasRecentDiseases: healthMetrics.hasRecentDiseases,
                  hasSymptoms: healthMetrics.hasSymptoms,
                  isPregnantOrNursing: healthMetrics.isPregnantOrNursing,
                  HIVTestAgreement: healthMetrics.HIVTestAgreement,
              },
          };
    
            // Gửi yêu cầu tới API backend
            const response = await axiosInstance.post(`/appointments/save`,formattedData, {
                params: {
                    username: username,
                    eventId: eventId     
                },
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json",
                },
            });
            console.log("Data fetched:", response?.data.statusCode);
            return response?.data; // Đảm bảo trả về mảng rỗng nếu không có dữ liệu
        } catch (err) {
            // Xử lý lỗi và thông báo chi tiết
            console.error("Error fetching events by date range:", err.message);
            if (err.response && err.response.data) {
                console.error("Server response:", err.response.data);
            }
            throw new Error("Không thể tải danh sách sự kiện. Vui lòng thử lại sau.");
        }
      }
        //Get By IdId
      static async getAppointmentById(id, token){
        try{
            const response = await axiosInstance.get(`/appointments/get/${id}`, 
            {
                headers: {Authorization: `Bearer ${token}`}
            })
            console.log("ress", response.data);
            return response.data;
        }catch(err){
            throw err;
        }
    }
      //Get trang thai pending
      static async getAppointmentPendingUser(token,username) {
        try {
            // Kiểm tra token
            if (!token) {
                throw new Error("Token is required.");
            }
    
            // Gửi yêu cầu tới API backend
            const response = await axiosInstance.get(`/appointments/by-user-pending`, {
                params: {
                    username: username || "", // Chuỗi rỗng nếu không có username
            
                },
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json",
                },
            });
    
            console.log("Data fetched:", response?.data);
            return response?.data; // Đảm bảo trả về mảng rỗng nếu không có dữ liệu
        } catch (err) {
            // Xử lý lỗi và thông báo chi tiết
            console.error("Error fetching events by date range:", err.message);
            if (err.response && err.response.data) {
                console.error("Server response:", err.response.data);
            }
            throw new Error("Không thể tải danh sách sự kiện. Vui lòng thử lại sau.");
        }
    }      

      //Get appointment by username
      static async getAppointmentByUser(token,username) {
        try {
            // Kiểm tra token
            if (!token) {
                throw new Error("Token is required.");
            }
    
            // Gửi yêu cầu tới API backend
            const response = await axiosInstance.get(`/appointments/by-user`, {
                params: {
                    username: username || "", // Chuỗi rỗng nếu không có username
            
                },
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json",
                },
            });
    
            console.log("Data fetched:", response?.data?.appointmentDTOList);
            return response?.data?.appointmentDTOList || []; // Đảm bảo trả về mảng rỗng nếu không có dữ liệu
        } catch (err) {
            // Xử lý lỗi và thông báo chi tiết
            console.error("Error fetching events by date range:", err.message);
            if (err.response && err.response.data) {
                console.error("Server response:", err.response.data);
            }
            throw new Error("Không thể tải danh sách sự kiện. Vui lòng thử lại sau.");
        }
    }      

    //Delete
    static async deleteAppointment(id,token){
        try{
            const response = await axiosInstance.delete(`/appointments/delete/${id}`, 
            {
                headers: {Authorization: `Bearer ${token}`}
            })
            return response.data;
        }catch(err){
            throw err;
        }
    }

    //update Status
    static async updateAppointmentStatus(token, id, status) {
        if (!token) {
          throw new Error("Token is required.");
        }
      
        try {
          const response = await axiosInstance.put(`/appointments/status`, null, {
            params: { id, status },
            headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
          });
      
          return response.data;  // Trả về dữ liệu thành công
        } catch (error) {
          console.error("Error updating appointment status:", error);
          throw error;  // Ném lỗi nếu có
        }
      }
      

      //FAQ
    //Add faq
    static async addFaq(token, faqData) {
        if (!token) {
            throw new Error("Token is required");
        }
    
        try {
            const response = await axiosInstance.post(
                `/faq/add`,
                faqData, // Dữ liệu sẽ được gửi trong body
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                        "Content-Type": "application/json",
                    },
                }
            );
    
            return response;  // Trả về dữ liệu thành công
        } catch (error) {
            console.error("Error adding FAQ:", error);
            throw error;  // Ném lỗi nếu có
        }
    }

    static async getAllFaq() {
        try {
          const response = await axiosInstance.get('/faq');
    
          // Log dữ liệu trả về để kiểm tra cấu trúc của nó
          console.log("Dữ liệu API trả về:", response.data);
          
          // Kiểm tra nếu dữ liệu có trường newsDTO
          if (response.data ) {
            return response.data; // Trả về toàn bộ dữ liệu từ API
          } else {
            console.error("Dữ liệu không có trường newsDTO");
            return {}; // Trả về object rỗng nếu dữ liệu không đúng
          }
        } catch (err) {
          console.error("Lỗi khi gọi API getAllNews:", err.message);
          throw err;
        }
      }

      //update FaQFaQ
      static async updateFAQ(id, title, description, token) {
        try {
          // Create FormData to send title, description, and potentially a file
          const formData = new FormData();
          formData.append("title", title);
          formData.append("description", description);
      
          const result = await axiosInstance.put(`/faq/update/${id}`, formData, {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "multipart/form-data", // Make sure it's set for multipart
            },
          });
      
          return result.data;
        } catch (error) {
          console.error("Error updating FAQ:", error);
          throw error; // Throw error for handling in calling functions
        }
      }
      
    static async getFaqById(token, id){
        try{
            const response = await axiosInstance.get(`/faq/${id}`,{
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "multipart/form-data",  // Đảm bảo header này được thiết lập
                    },
            });
            console.log("Data: ", response.data);
            return response.data;
        }catch(error){
            throw error;
        }
       
    }
    static async deleteFaq(token, id) {
        try {
            const response = await axiosInstance.delete(`/faq/delete/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`, // Authorization header with the token
                },
            });
            return response.data; // Return the response data (can include success message or status)
        } catch (err) {
            console.error("Error deleting FAQ:", err); // Log the error for debugging
            throw err; // Rethrow the error so it can be handled in the component
        }
    }


    //BloodInventory
    //update Blood Inventory
  static async updateBloodInventory(token,id, bloodInventoryDTO) {
  // bloodInventoryDTO phải có các trường: id, donationType, quantity, lastUpdated, expirationDate, appointmentTO
    try {
      const response = await axiosInstance.put(`/blood-inventory/update/${id}`, bloodInventoryDTO, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}` // Truyền token vào headers
        }
      });

      if (response.status !== 200) {
        throw new Error("Failed to update blood inventory");
      }
      return response.data; // Trả về dữ liệu thành công
    } catch (error) {
      console.error("Error updating blood inventory:", error);
      throw error; // Ném lỗi nếu có
    }
  }
  
    //Get all
    static async getAllBloodInventory(token) {
        try {
          const response = await axiosInstance.get('/blood-inventory', {
            headers: { Authorization: `Bearer ${token}` }
          });
    
       
          console.log("Dữ liệu API trả về:", response.data);
          
       
          if (response.data ) {
            return response.data;
          } else {
            console.error("Dữ liệu không có trường newsDTO");
            return {}; 
          }
        } catch (err) {
          console.error("Lỗi khi gọi API getAllNews:", err.message);
          throw err;
        }
      }
    // Get By Id
    static async getBloodInventory(token, id) {
        try {
          const response = await axiosInstance.get(`/blood-inventory/${id}`, {
            headers: { Authorization: `Bearer ${token}` }
          });

          console.log("Dữ liệu API trả về:", response.data);
       
          if (response.data ) {
            return response.data;
          } else {
            console.error("Dữ liệu không có trường newsDTO");
            return {}; 
          }
        } catch (err) {
          console.error("Lỗi khi gọi API getAllNews:", err.message);
          throw err;
        }
      }
    static async deleteBloodInventory(id, token){
            try{
                const response = await axiosInstance.delete(`/blood-inventory/delete/${id}`, 
                {
                    headers: {Authorization: `Bearer ${token}`}
                })
                return response.data;
            }catch(err){
                throw err;
            }
      }

      //add
      static async addBloodInventory(token, payLoad, appointmentId) {
        try {
          const response = await axiosInstance.post(
            `/blood-inventory/add?appointmentId=${appointmentId}`,
            payLoad,
            {
              headers: { Authorization: `Bearer ${token}` },
            }
          );
      
          console.log("Dữ liệu API trả về:", response.data);
      
          if (response.data && response.data.success) {
            return response.data; 
          } else {
            console.error("Dữ liệu không hợp lệ hoặc không có trường success");
            return { error: "Dữ liệu không hợp lệ" };
          }
        } catch (err) {
          console.error("Lỗi khi gọi API:", err.response ? err.response.data : err.message);
          
          throw new Error(err.response ? err.response.data.message : "Có lỗi xảy ra khi gọi API");
        }
      }

        static async chat(message) {
          try {
            const response = await axiosInstance.post("/api/chat", { message }, {
              headers: {
                "Content-Type": "application/json", // Ensure Content-Type is set
              },
            });
      
            console.log(response);

            if (response.status !== 200) {
              throw new Error("Failed to fetch");
            }
      
            return response.data;  // assuming the response has a message property
          } catch (error) {
            console.error("Error in UserService:", error);
            throw error;
          }
        }

        static async getOptions(username) {
          try {
            const response = await axiosInstance.get(`/api/chat/getOptions/${username}`, {
              headers: {
                "Content-Type": "application/json", // Ensure Content-Type is set
              },
            });
      
            console.log(response);
      
            // Check if the response status is OK
            if (response.status !== 200) {
              throw new Error("Failed to fetch options");
            }
      
            return response.data;  // Returning the options map directly from the response
          } catch (error) {
            console.error("Error in UserService:", error);
            throw error;
          }
        }
}

export default UserService;