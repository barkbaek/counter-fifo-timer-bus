# COUNTER (FIFO & BUS & TIMER)
#### <b>Language : Verilog</b> <br>
<br>

### 1. 그림 목차 <br>
#### 1-1. Schedule <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456238171/img1_wun0na.png)
<br>

#### 1-2. State Transition Diagram - Synchronous FIFO <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456238869/img2_vicvwt.png)
<br>

#### 1-3. State Transition Diagram - TIMER - module이름 : timer_reg  - CNT_EN_STATE <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img3_yogjmq.png)
<br>

#### 1-4. State Transition Diagram - TIMER - module이름 : timer_reg  - INTRRT_STATE <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img4_enmrbv.png)
<br>

#### 1-5. State Transition Diagram - TIMER - module이름 : timer_master - master_state <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img5_fvlpnh.png)
<br>

#### 1-6. State Transition Diagram - TIMER - module이름 : timer_counter - counter_state <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242272/img6_l8du4f.png)
<br>

#### 1-7. State Transition Diagram - BUS <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242271/img7_hkjebz.png)
<br>

#### 1-8. Schematic symbol of TOP & bus의 간략한 내부 system 구성 화면 <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242272/img8_wj0fg5.png)
<br>

#### 1-9. Verilog로 구현한 FIFO_TOP 내부 회로 구성 화면 1. - WRITE OPERATION 요청 시 ( 회로가 커서 WRITE와 READ로 나눠서 삽입하였음 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img9_iwqmjc.png)
<br>

#### 1-10. Verilog로 구현한 FIFO_TOP 내부 회로 구성 화면 2. - READ OPERATION 요청 시 ( 회로가 커서 WRITE와 READ로 나눠서 삽입하였음 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img10_w0jufq.png)
<br>

#### 1-11. Design Verification ( fifo 1 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img11_xlw3ib.png)
<br>

#### 1-12. Design Verification ( fifo 2 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img12_kd7dak.png)
<br>

#### 1-13. Design Verification ( fifo_top 1 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img13_ihpnyz.png)
<br>

#### 1-14. Design Verification ( fifo_top 2 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242273/img14_ldddm4.png)
<br>

#### 1-15. Design Verification ( timer 1 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242274/img15_rl0dvs.png)
<br>

#### 1-16. Design Verification ( timer 2 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img16_ft0jwb.png)
<br>

#### 1-17. Design Verification ( bus ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img17_diougi.png)
<br>

#### 1-18. Design Verification ( top1 ) ( top2, top3까지 연결됨 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242274/img18_dloxzb.png)
<br>

#### 1-19. Design Verification ( top2 )  ( top1, top3과 연결됨 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242274/img19_o6mxns.png)
<br>

#### 1-20. Design Verification ( top3 )  ( top1, top2와 연결됨 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img20_qbecug.png)
<br>

#### 1-21. Design Verification ( top4 )  ( ※ INVALID한 입력 - LOAD_ADDRESS 값이 8'h23일 때 ) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/img21_kjfoyr.png)
<br>
<br>
<br>
### 2. 표 목차 <br>
#### 2-1. Input/Output Description (Synchronous FIFO) - (5-1. Synchronous fifo) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/table1_pe76il.png)
<br>

#### 2-2. Input/Output Description (FIFO-TOP) - (5-2. fifo-top) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242275/table2_qnm00y.png)
<br>

#### 2-3. Input/Output Description (TIMER) - (5-3. timer) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table3_p7yfej.png)
<br>

#### 2-4. Input/Output Description (Register Description (in Timer)) - (5-3. timer) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table4_xjnq2m.png)
<br>

#### 2-5. Input/Output Description (BUS) - (5-4. bus) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table5_eceltf.png)
<br>

#### 2-6. Input/Output Description (TOP) - (5-5. top) <br>
![alt tag](http://res.cloudinary.com/remotecontrol/image/upload/v1456242276/table6_dytwm0.png)
<br>
<br>
<br>

### 3. Project 소개 <br>
####  3-1. Project 구현
###### FIFO, TIMER, BUS를 연결하여 동작하는 		 COUNTER를 설계한다.
<br>
#### 3-2. 목적
###### - 과제에서 주어진 specification을 충분히 이해하고 과제를 수행한다.
###### - State Transition을 구성하고 FSM 설계 능력을 향상한다.
###### - testbench에서 Invalid한 입력이 주어졌을 때 어떻게 대처해야 효율적으로 작동할 수 있을지 여러 대처방안을 고안해보고 예외처리에 대한 생각을 넒힘으로써 회로 구현 능력을 향상시킨다.
<br>
<br>
<br>
### 4. 일정 및 계획 <br>
#### 4-1. Project 구현 일정 및 계획
###### - 1. Schedule 참고
###### - Project 제안서에서 계획했던 일정과 조금의 변화가 있어 다시 수정하였다. 2011년 11월 2일부터 2011년 11월 12일까지 주어진 specification을 제대로 이해하고 계획을 세웠다.
###### - 2011년 11월 13일부터 2011년 11월 16일까지 FIFO, FIFO-TOP, BUS, TIMER에 관한 State Transition Diagram을 작성하였고 각 module에 관한 상세 spec을 설계하였다.
###### - 2011년 11월 17일부터 2011년 11월 22일까지 각각의 module을 Verilog code로 구현하였다.
###### - 2011년 11월 23일부터 2011년 12월 3일까지 구현한 Verilog code를 검증하였다. 2011년 11월 29일에 첫 번째 예비 검증을 수행하였고 2011년 12월 3일 두 번째 예비 검증을 수행하였다.
###### - 2011년 12월 4일부터 2011년 12월 4일부터 2011년 12월 6일까지 최종 결과보고서를 작성하였다.
<br>
<br>
<br>
### 5. Project Specification <br>
#### 5-1. Synchronous fifo
###### - 표 2-1. Input/Output Description (Synchronous FIFO) 참고
<br>
##### 5-1-1. Introduction
###### - Synchronous FIFO 는 First-In-First-Out memory queue로 내부에 read와 write에 관한 pointer를 관리하는 control logic이 있어 	  status flags를 생성하고 user logic과 interface하기 위한 handshake signal을 제공한다.
<br>
##### 5-1-2. Features
###### - Data width가 8bits인 8개의 data를 저장할 수 있는 memory depth를 가진다.
###### - Status flag로 full과 empty를 제공한다.
###### - Handshake signal인 wr_ack, wr_err, rd_ack, rd_err를 통해 write와 read 요청에 관한 feedback을 제공한다.
###### - data_count를 통해 fifo안에 있는 현재 data 수를 확인할 수 있다.
<br>
##### 5-1-3. Functional Description
###### - write-enable input(wr-en)이 1이면, clock의 rising edge에서 다음에 이용할 수 있는 memory의 빈 공간에 쓰여지며 Memory full status output(full)은 module 내부 memory에 더 이상 빈 공간이 없음을 나타낸다.
###### - Synchronous fifo에 저장된 data는 clock의 rising edge에서 read-enable input(rd_en)이 1이면 쓰여진 순서대로 output port인 dout을 통해 빠져나간다. Memory empty status output(empty)의 값이 1이면 내부 memory에 더 이상 data가 존재하지 않음을 나타낸다.
###### - fifo는 invalid request에 의해 손상되어서는 안된다. empty flag의 상태가 활성화 되어있거나 full flag가 활성화 되었을 때 각각 read operation과 write operation을 요청할 때 fifo에 어떠한 영향도 미쳐서는 안된다. Handshake signal인 read error output(rd_err)과 write error output(wr_err)은 이러한 invalid request의 error가 발생했음을 알려준다.
<br>
##### 5-1-4. Behaviors of status signals
###### - Active low에 동작하는 reset_n은 내부 포인터를 재설정한다. (empty status output은 1로 하고, full status output은 0으로 초기화한다. reset_n을 통해 fifo에 저장되어 있지만 read되지 않은 data를 버림으로써 효과적으로 fifo 내부를 비울 수 있게 해준다.)
###### - Write acknowledge output(wr_ack)는 요청된 write 신호에 대해 승인함을 알려준다. (fifo 상태가 full 이 아닐 때.)
###### - Write error output(wr_err)는 요청된 write 신호에 대해 거부함을 알려준다. (fifo의 상태가 full일 때.)
###### - Read acknowledge output(rd_ack)는 요청된 read 신호에 대해 승인함을 알려준다. (fifo의 상태가 empty가 아닐 때.)
###### - Read error output(rd_err)는 요청된 read 신호에 대해 거부함을 알려준다. (fifo의 상태가 empty일 때.)
###### - write가 요청되면 read 요청은 될 수 없고, read가 요청되면 write가 요청될 수 없다.
###### - write와 read가 둘 다 요청 되지 않을 경우 비활성화 된다.
<br>
##### 5-1-5. Additional Information
###### - FIFO에서 read enable signal(rd_en)이 1이 되는 경우, output port인 dout으로 0을 보낸다.
<br>
<br>
<br>
#### 5-2. fifo-top
###### - 표 2-2. Input/Output Description (FIFO-TOP) 참고.
<br>
##### 5-2-1. Introduction
###### - 내부에 synchronous FIFO 4개를 instance한 component이다. 외부로부터 해당 component가 선택되었을 경우 입력된 address signal과 write/read signal을 해독하여 4개 중 하나의 FIFO를 선택하여 read/write를 수행한다.
<br>
##### 5-2-2. Features
###### - Select signal(sel)이 1일 때 작동한다.
###### - Write/Read signal(wr)이 1이면 write operation을 처리하고 0이면 read operation을 처리한다.
###### - 각각의 Synchronous FIFO의 주소는 8bits이며 Address signal은 이 fifo를 선택하기 위해 사용된다. 이중 상위 4bits는 사용하지 않고 하위 4bits를 offset으로 사용하여 4개의 fifo 중 하나를 선택한다.
###### - Data in signal(din) 은 bus를 통해 입력된 data로 4개 fifo의 data in과 연결되고, Data out signal(dout)은 4개의 FIFO 중 선택된 FIFO의 dout을 결과로 연결한다.
###### - 4개의 FIFO 중 선택된 FIFO의 handshake signal, status flag, count vector를 연결하여 출력한다.
<br>
##### 5-2-3. Functional Description
###### - 4개의 FIFO는 offset이 각각 0x1, 0x2, 0x3, 0x4이며 그 외의 값일 경우에는 아무 일도 수행하지 않는다. (Synchronous FIFO 각각의 offset은 8'h11, 8'h12, 8'h13, 8'h14이다.)
###### - Select signal(sel)이 1일 때, wr_en이 1이면 data_in input(din)이 FIFO에 쓰여지도록 요청된 것이고 read enable signal(rd_en)이 1이면 FIFO에 저장되어 있는 값을 읽도록 요청된 것이다. 4개의 FIFO중 하나가 선택되었을 때 해당 FIFO에서 나오는 status flag, handshake signal, count vector 값을 FIFO TOP의 FIFO flag output(fifo_flag)와 FIFO count value(fifo_cnt)를 통해 출력된다. FIFO flag output(fifo_flag)은 6bits 값을 가지는데 각각의 비트는 최상위부터 순서대로 full, empty, write acknowledge(wr_ack), write error(wr_err), read acknowledge(rd_ack), read error(rd_err)를 나타낸다. 4개 중 아무것도 선택되지 않았을 경우 FIFO flag output(fifo_flag)과 FIFO count value(fifo_cnt)는 모두 0을 출력한다.
<br>
##### 5-2-4. Additional Information
###### - FIFO top에서 instance하는 4개의 Synchronous FIFO의 instance 이름은 각각 ‘U0_fifo', 'U1_fifo', 'U2_fifo', 'U3_fifo'로 정의한다.
###### - FIFO TOP module 이 선택되었지만 (sel == 1) 입력된 address가 4개의 FIFO중 아무것도 선택되지 않을 경우 아무 일도 하지 않는다. (하위 4bits offset이 0x1, 0x2, 0x3, 0x4가 아닐 경우)
<br>
<br>
#### 5-3. timer
###### - 표 2-3. Input/Output Description (TIMER) & 표 2-4. Input/Output Description 	(Register Description (in Timer)) - 참고.
<br>
##### 5-3-1. Introduction
###### - 입력으로 들어오는 펄스(CLOCK)를 특정 수만큼 count 하는 장치로 count 명령을 받으면 내부 load address register(해당 FIFO)에 저장된 값을 address로 하여 값을 읽어와 count한다. 클록이 상승에지일 때마다 count가 1씩 감소하며 count 값이 0으로 끝나면 interrupt를 발생시킨다.
<br>
##### 5-3-2. Features
###### - bus에 연결되어 동작한다.
###### - Master interface와 Slave interface를 가진다.
###### - Address input(M_address, S_address)는 모두 8bits이다.
###### - Data input/output(M_dout, M_din, S_dout, S_din)은 모두 8bits다.
###### - bus를 통해 data transfer를 요청하고자 할때 Master request output(M_req)는 1이 된다.
###### - M_req를 요청하고 bus에서 허락할 때 M_grant는 1이 된다. M_grant가 1이 되면 timer는 master address output(M_address), master write/read output(M_wr), master data-out output(M_dout)를 통하여 해당 주소의 레지스터에 접근하며 그 레지스터에 저장되어있는 data를 master data-in input(M_din)을 통해 가져온다.
###### - slave interface를 통해 timer의 내부 register를 외부에서 제어할 수 있다. 제어가 필요한 register들은 각각 offset을 가지고 있다.
###### - 해당 FIFO에서 읽어온 data 값만큼 count down을 수행한다.
###### - Timer에서 count할 수 있는 값은 1 ~ 255 (0x1 ~ 0xFF)이며, count 값이 0일 경우에는 count를 수행하지 않는다. (※ FIFO에서 load하여 받은 값이 0일 경우 count를 수행하지 않는다.)
###### - count가 끝나면 interrupt를 발생시킴으로써 testbench에게 count가 끝났음을 통지한다.
<br>
##### 5-3-3. Functional Description
###### - TIMER는 외부로부터 제어를 받고 master interface를 통해 외부를 제어할 수 있다.
###### - Slave interface는 pin이름이 'S_'로 시작하고 Master interface는 'M_'으로 시작한다.
###### - 외부에서 timer를 동작시키기 위해서는 timer의 내부 상태가 IDLE 상태일 때, count enable(CNT_EN) register에 1이 쓰여져야 한다. CNT_EN이 1이 되면 timer는 내부 load address(LOAD_ADDRESS) register에 저장되어 있는 값을 address로 하여 해당 위치의 값을 읽어오고 읽어온 값을 count한다. count가 끝나고 interrupt가 발생하는데 내부 interrupt(INTRRUPT) register에 0을 써서 clear할 수 있다. interrupt가 clear된 후 continuous count(CNT_CON) register의 값이 1이면 해당 LOAD_VALUE register에 저장되어 있는 값을 COUNT_VALUE register에 복사하여 다시 count를 수행하고 continuous count(CNT_CON) register의 값이 0이면 더 이상 count를 수행하지 않으며 IDLE STATE으로 돌아가 대기한다.
<br>
##### 5-3-4. Register Description
###### - Timer는 8bits register를 가지고 있다.
###### - 표 2-4. Input/Output Description (Register Description (in Timer))을 참고하면 알 수 있듯이 type이 'W'인 경우 해당 register에 write operation만 가능하고 type이 ‘R'인 경우 해당 register의 값을 read하는 것만 가능하며 ’R/W'일 경우 해당 register에 값을 쓰거나 해당 register의 값을 읽을 수 있다.
<br>
##### 5-3-5. Additional Information
###### - CUR_STATE register는 해당 register의 값을 read했을 때 0x00이면 IDLE 상태로 한다. (IDLE 상태는 어떠한 동작도 하지 않는 상태이다.)
###### - CNT_EN register는 IDLE 상태일 때 1이 쓰이면 외부로부터 값을 읽은 후 count를 시작하도록 구현하며 그 외의 경우에 CNT_register에 1이 쓰이면 무시한다.
###### - M_req port가 1이고 bus의 응답으로 M_grant port가 1이 되면 1 cycle 동안 LOAD ADDRESS register의 값을 요청 후 읽어진 data로 count한다.
###### - CNT_EN register의 값을 read 하려고 할 경우 slave data out(S_dout) port에 0x00을 출력한다.
###### - interrupt(INTRRUPT) register는 interrupt가 발생했을 때, 0을 write함으로써 interrupt를 clear 시키는 역할을 한다. 그 외의 경우에 register를 write 하는 것은 무시한다.
###### - interrupt(INTRRUPT) register에 read 요청이 들어오면 interrupt가 발생했을 때 slave data out(S_dout) portf를 통해 1을 출력하고 interrupt가 발생하지 않았을 때는 0을 출력한다.
###### - CNT_CON register의 값은 언제든 read하거나 write 할 수 있다.
###### - LOAD_ADDRESS register의 값은 언제든 read하거나 write 할 수 있다.
###### - 해당 레지스터의 값을 읽을 수 밖에 없게 설정된 LOAD_VALUE register와 COUNT_VALUE register, CUR_STATE register에 write operation이 요청되면 timer는 이를 무시한다.
###### - Master interface를 통해 read한 값을 LOAD VALUE register에 저장하며 이 값을 계속 유지한다. (reset_n이 활성화될 때와 다시 Master interface를 통해 data를 read할 경우 제외.)
###### - COUNT_VALUE register는 reset_n이 되었을 경우 default value(0x00)을 가지며 count를 하고 있지 않을 때 0을 가진다.
<br>
<br>
#### 5-4. bus
###### 
<br>
##### 5-4-1. Introduction
###### 
<br>
##### 5-4-2. Features
###### 
###### 
###### 
###### 
###### 
###### 
###### 
<br>
##### 5-4-3. Functional Description
###### 
<br>
##### 5-4-4. Additional Information
###### 
###### 
<br>
#### 5.5. top
###### - ※pg10의 표 2-6. Input/Output Description 	(TOP) 참고
<br>
##### 5-5-1. Introduction
###### - TOP은 FIFO TOP, TIMER, BUS를 instance 하	  여 연결한 component이다.
<br>
##### 5-5-2. Features
###### 
###### 
###### 
<br>
##### 5-5-3. Additional Information
###### 
<br>
<br>
<br>
### 6. Design details <br>
#### 6-1. Synchronous fifo
######
<br>
##### 6-1-1. 구현한 내부 module 소개
######
######
######
######
######
######
<br>
##### 6-1-2. fifo_STATE 소개
###### <b>- 6-1-2-1. fifo_INIT_STATE</b>
###### 
<br>
###### <b>- 6-1-2-2. fifo_INIT_READ_ERR_STATE</b>
###### 
###### 
<br>
###### <b>- 6-1-2-3. fifo_WRITE_STATE</b>
###### 
###### 
###### 
###### 
<br>
###### <b>- 6-1-2-4. fifo_FULL_STATE</b>
###### 
###### 
###### 
###### 
<br>
###### <b>- 6-1-2-5. fifo_WRITE_ERR_STATE</b>
###### 
###### 
###### 
###### 
<br>
###### <b>- 6-1-2-6. fifo_READ_STATE</b>
###### 
###### 
###### 
###### 
<br>
###### <b>- 6-1-2-7. fifo_EMPTY_STATE</b>
###### 
###### 
###### 
###### 
<br>
###### <b>- 6-1-2-8. fifo_READ_ERR_STATE</b>
###### 
###### 
###### 
<br>
###### <b>- 6-1-2-9. fifo_NOP_STATE</b>
<br>

