## Tổng quan dự án
Thiết kế sử dụng đồng bộ 2 con trỏ Gray code và đồng bộ 2 flip-flop để truyền thông tin con trỏ giữa các miền xung nhịp một cách an toàn, đồng thời giảm thiểu metastability.
Các con trỏ Gray sau khi đồng bộ được so sánh trực tiếp để tạo cờ full và empty, không chuyển ngược lại sang nhị phân.
Dự án được thiết kế RTL kiểu chia module và SystemVerilog testbench để tự kiểm tra để xác minh chức năng.

## Tại sao cần FIFO bất đồng bộ?
Trong các hệ thống số hiện đại, các thiết bị thường có tần số  xung nhịp hoạt động khác nhau.
Ví dụ:
  Bộ xử lí <-> Ngoại vi
  Camera <-> pipeline hiển thị

Truyền trực tiếp các thiết bị nhiều bit ở các miền xung nhịp có thể gây ra metastability và hỏng dữ liệu.
FIFO bất đồng bộ có thể giải quyết bằng cách:
  - Đệm dữ liệu giữa 2 miền xung nhịp.
  - Bảo toàn dữ liệu an toàn.
  - 
    
