#  Advanced Customer Segmentation & Marketing Campaign Analytics

Dự án triển khai quy trình trinh sát dữ liệu tự động, xử lý nhiễu hệ thống (Outliers/Missing values) bằng kỹ thuật thống kê chuyên sâu và kiến trúc các đặc trưng (Feature Engineering) phục vụ bài toán tối ưu hóa tỷ lệ ROI cho chiến dịch Marketing đa kênh.

---

##  1. Mục Tiêu Chiến Lược (Project Objectives)
* **Kỹ thuật hệ thống:** Thiết lập pipeline tự động hóa quy trình rà soát và phát hiện bất thường cấu trúc trên tập dữ liệu đa chiều ($D > 20$).
* **Giải pháp Thống kê:** Áp dụng toán tử phân vị (`IQR`, `Winsorization`) và thuật toán điền khuyết có điều kiện (`Group Median Imputation`) nhằm bình ổn hàm phân phối của dữ liệu, triệt tiêu nhiễu đồ thị nhưng bảo toàn $100\%$ hành vi của phân khúc khách hàng VIP.
* **Tối ưu hóa Thương mại:** Trích xuất các chỉ số phân phối đặc trưng phục vụ phân đoạn thị trường, định hình chân dung nhóm $15\%$ khách hàng mục tiêu để chuyển đổi từ chiến lược tiếp thị đại trà sang tiếp thị định hướng dữ liệu.

---

##  2. Quy Trình Xử Lý Dữ Liệu & Tư Duy Kiến Trúc Hệ Thống

### A. Trinh sát & Quét lỗi dữ liệu tự động (Automated EDA Pipeline)
* Thay vì rà soát thủ công, hệ thống sử dụng thuật toán quét tự động dựa trên chỉ số **IQR (Interquartile Range)** và độ lệch phân phối **(Skewness)**. Phương pháp này tối ưu hóa thời gian xử lý dữ liệu lớn, lập tức định vị các trường dữ liệu có phương sai dị biệt để kích hoạt phân tích sâu.

### B. Chiến lược xử lý Outliers (Giá trị ngoại lai) theo Bản chất Thống kê
Dữ liệu bất thường được phân loại và xử lý nghiêm ngặt dựa trên bản chất gốc của biến:
* **Phương pháp Loại bỏ (Trimming/Dropping):** Khử hoàn toàn các dòng sai lệch quy luật vật lý do lỗi nhập liệu hệ thống (Khách hàng sinh năm $\le 1940$ tức $\ge 74$ tuổi tại thời điểm collect; hoặc lỗi gõ thừa ký tự `Income = 666,666`). Quy mô mẫu được tinh gọn từ $2,216$ về $2,212$ bản ghi sạch.
* **Phương pháp Ép biên (Winsorization):** Đối với nhóm khách hàng siêu VIP có thu nhập từ $\$153,000$ đến $\$162,000$, việc xóa bỏ sẽ làm mất cấu trúc chi tiêu thực tế. Dự án áp dụng **Winsorization tại Percentile 99 ($\$94,384$)**. Kỹ thuật này bẻ gãy các điểm cực trị làm méo mó các mô hình tính toán khoảng cách (như K-Means) nhưng bảo toàn nguyên vẹn hành vi mua sắm của nhóm.

### C. Điền khuyết nâng cao dựa trên Phân vị Nhóm (Group Median Imputation)
* Trường dữ liệu `Income` khuyết thiếu được xử lý bằng thuật toán **Điền khuyết dựa trên trung vị của nhóm Trình độ học vấn (`Education`)**. Việc sử dụng toán tử `transform('median')` giúp phân phối của biến không bị dịch chuyển lệch lạc. Minh chứng: Giá trị trung bình ($\mu = 51,724$) và trung vị ($\text{Median} = 51,371$) sau xử lý đạt trạng thái hội tụ cao (sai lệch $\Delta < 400$ đơn vị).

### D. Kỹ nghệ Đặc trưng (Feature Engineering)
* **Trích xuất Thời gian (Temporal Features):** Chuyển đổi định dạng `datetime64[ns]` cho cột `Dt_Customer`. Tính toán `Age` (Tuổi) dựa trên mốc phân tích và ép kiểu biến `Customer_Tenure` (Số ngày gắn bó) từ định dạng chuỗi thời gian `Timedelta` về dạng số nguyên thuần túy (`int64`) bằng toán tử `.dt.days` để mô hình Machine Learning có thể tiếp nhận.
* **Tích hợp Ma trận Tổng lực (Aggregated Features):** Cấu trúc hóa các biến tổng hợp `Total_Spent` (Tổng chi ngạch 6 nhóm mặt hàng) và `Total_Purchases` (Tổng tần suất giao dịch trên 3 kênh phân phối) nhằm giảm chiều dữ liệu ($Dimensionality Reduction$), tăng cường độ cô đọng thông tin cho khâu phân đoạn.

---

##  3. Kết Quả Phân Tích Định Lượng & Insights Thương Mại

###  A. Phân phối Doanh thu theo Nhân khẩu học (Age Group Analysis)
* **Số liệu thực nghiệm:** Nhóm khách hàng $\ge 45$ tuổi (Trung niên & Lớn tuổi) chiếm $78.6\%$ dung lượng mẫu ($N = 1,740$) nhưng kiểm soát đến **$80.0\%$ tổng chi ngạch** toàn hệ thống. Ngược lại, nhóm trẻ (`Under 30`) chỉ đạt quy mô biên $0.45\%$ mẫu và đóng góp $1.0\%$ doanh thu.
* **Giải pháp Chiến lược:** Tập trung $80\%$ ngân sách Marketing vào tệp $\ge 45$ tuổi. Cấu trúc lại UI/UX của hệ thống Frontend (Website/App) theo hướng tối giản, tăng kích thước font chữ (chuẩn AAA) và rút ngắn User Flow để tối ưu hóa tỷ lệ chuyển đổi cho người lớn tuổi. Nhóm trẻ tuổi tuy quy mô nhỏ nhưng có chỉ số tài chính mạnh ($\mu_{\text{Income}} = \$58,181$, $\mu_{\text{Purchases}} = 14.0$), cần các chiến dịch kích cầu chuyên biệt (Gamification, tích hợp ví điện tử).

###  B. Hiệu năng Hệ thống Kênh phân phối (Channel Efficiency)
* **Số liệu thực nghiệm:** Kênh Cửa hàng trực tiếp (`Store`) xử lý lượng đơn hàng lớn nhất với $46.2\%$ thị phần giao dịch ($12,844$ transactions). Kênh `Website` bám đuổi với $32.5\%$ ($9,043$ transactions) và kênh `Catalog` duy trì ổn định ở mức $21.3\%$ ($5,911$ transactions).
* **Giải pháp Chiến lược:** Triển khai mô hình tích hợp dữ liệu đa kênh *Click-and-Collect* (Đặt trực tuyến, nhận tại cửa hàng) nhằm tối ưu vận hành kho bãi và kích hoạt thuật toán bán chéo (Cross-selling) tại Store. Áp dụng phân lớp dữ liệu để chỉ phân phối `Catalog` vật lý đến nhóm khách hàng có Score trung thành cao và thu nhập $> \$55k$ để triệt tiêu chi phí in ấn đại trà.

###  C. Chân dung Phân khúc Mục tiêu Tối ưu hóa Chỉ số ROI (Response Analysis)
Chiến dịch ghi nhận tỷ lệ phản hồi tích cực đạt $15.05\%$ ($333/2,212$ khách hàng). Đối chiếu phân phối thực nghiệm giữa hai nhóm phản hồi (`Response=1`) và từ chối (`Response=0`) cho thấy:
* **Thu nhập ($\mu_{\text{Income}}$):** Nhóm `Response=1` đạt **$\$60,076.7$**, vượt trội **$+19.5\%$** so với nhóm `Response=0` ($\$50,244.3$).
* **Sức mua ($\mu_{\text{Total\_Spent}}$):** Nhóm `Response=1` đạt **$\$985.7$**, bứt phá tăng trưởng **$+82.5\%$** so với nhóm từ chối ($\$540.2$).
* **Độ trung thành ($\mu_{\text{Customer\_Tenure}}$):** Thời gian gắn bó đạt **$448.1$ ngày**, dài hơn nhóm từ chối **$+33.0\%$** ($337.0$ ngày).
* **Biến số Tuổi tác:** Không ghi nhận sự khác biệt có ý nghĩa thống kê ($\mu \approx 54.5 \text{ vs } 55.2$).

**🚀 Giải pháp Thực thi Kỹ thuật (Targeting Query Engine):**
Chấm dứt hoàn toàn việc spam tin nhắn/email tiếp thị đại trà. Hệ thống Backend cần thiết lập cấu trúc truy vấn lọc cứng trước khi phân phối Campaign, chỉ quét các Account thỏa mãn điều kiện biên phân vị toán học:
$$\text{Target Audience Filter} = \begin{cases} \text{Income} \ge \$55,000 \\ \text{Customer\_Tenure} \ge 350 \text{ days} \end{cases}$$
Giải pháp này cắt giảm ngay lập tức hơn $70\%$ chi phí vận hành quảng cáo rác, tập trung chính xác nguồn lực vào nhóm khách hàng VIP có sức mua gấp đôi hệ thống.

---

##  4. Kiến Trúc Mã Nguồn Dự Án (Repository Structure)
* `data/`: Thư mục lưu trữ tập dữ liệu cấu trúc gốc (`marketing_data.csv`).
* `notebooks/customer_segmentation.ipynb`: Môi trường Jupyter Notebook xử lý tuyến tính toàn bộ Pipeline từ Import, Làm sạch, Feature Engineering đến Trực quan hóa và Kết xuất báo cáo (Đã được dọn dẹp log rác và Suppress Warnings).
* `.gitignore`: Bộ lọc loại bỏ các file đệm hệ thống (`.ipynb_checkpoints`, `.DS_Store`).
* `README.md`: Tài liệu tóm tắt kiến trúc kỹ thuật và insights dự án.