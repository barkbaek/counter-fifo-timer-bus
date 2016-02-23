# COUNTER (FIFO & BUS & TIMER)
#### <b>Language : Verilog</b> <br>
<br>

### 1. 그림 목차 <br>
##### 1-1. Schedule <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456238171/img1_wun0na.png)
<br>

##### 1-2. State Transition Diagram - Synchronous FIFO <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456238869/img2_vicvwt.png)
<br>

##### 1-3. State Transition Diagram - TIMER - module이름 : timer_reg  - CNT_EN_STATE <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img3_yogjmq.png)
<br>

##### 1-4. State Transition Diagram - TIMER - module이름 : timer_reg  - INTRRT_STATE <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img4_enmrbv.png)
<br>

##### 1-5. State Transition Diagram - TIMER - module이름 : timer_master - master_state <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img5_fvlpnh.png)
<br>

##### 1-6. State Transition Diagram - TIMER - module이름 : timer_counter - counter_state <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242272/img6_l8du4f.png)
<br>

##### 1-7. State Transition Diagram - BUS <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img7_hkjebz.png)
<br>

##### 1-8. Schematic symbol of TOP & bus의 간략한 내부 system 구성 화면 <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242272/img8_wj0fg5.png)
<br>

##### 1-9. Verilog로 구현한 FIFO_TOP 내부 회로 구성 화면 1. - WRITE OPERATION 요청 시 ( 회로가 커서 WRITE와 READ로 나눠서 삽입하였음 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img9_iwqmjc.png)
<br>

##### 1-10. Verilog로 구현한 FIFO_TOP 내부 회로 구성 화면 2. - READ OPERATION 요청 시 ( 회로가 커서 WRITE와 READ로 나눠서 삽입하였음 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img10_w0jufq.png)
<br>

##### 1-11. Design Verification ( fifo 1 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img11_xlw3ib.png)
<br>

##### 1-12. Design Verification ( fifo 2 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img12_kd7dak.png)
<br>

##### 1-13. Design Verification ( fifo_top 1 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img13_ihpnyz.png)
<br>

##### 1-14. Design Verification ( fifo_top 2 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img14_ldddm4.png)
<br>

##### 1-15. Design Verification ( timer 1 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242274/img15_rl0dvs.png)
<br>

##### 1-16. Design Verification ( timer 2 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img16_ft0jwb.png)
<br>

##### 1-17. Design Verification ( bus ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img17_diougi.png)
<br>

##### 1-18. Design Verification ( top1 ) ( top2, top3까지 연결됨 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242274/img18_dloxzb.png)
<br>

##### 1-19. Design Verification ( top2 )  ( top1, top3과 연결됨 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242274/img19_o6mxns.png)
<br>

##### 1-20. Design Verification ( top3 )  ( top1, top2와 연결됨 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img20_qbecug.png)
<br>

##### 1-21. Design Verification ( top4 )  ( ※ INVALID한 입력 - LOAD_ADDRESS 값이 8'h23일 때 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img21_kjfoyr.png)
<br>
<br>
<br>
### 2. 표 목차 <br>
##### 2-1. Input/Output Description (Synchronous FIFO) - (5-1. Synchronous fifo) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/table1_pe76il.png)
<br>

##### 2-2. Input/Output Description (FIFO-TOP) - (5-2. fifo-top) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/table2_qnm00y.png)
<br>

##### 2-3. Input/Output Description (TIMER) - (5-3. timer) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table3_p7yfej.png)
<br>

##### 2-4. Input/Output Description (Register Description (in Timer)) - (5-3. timer) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table4_xjnq2m.png)
<br>

##### 2-5. Input/Output Description (BUS) - (5-4. bus) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table5_eceltf.png)
<br>

##### 2-6. Input/Output Description (TOP) - (5-5. top) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table6_dytwm0.png)
<br>
<br>
<br>

### 3. Project 소개 <br>
#####  <br>
