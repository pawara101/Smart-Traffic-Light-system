    ; EE 322 project smart traffic light system modeled for 4 way junction
    ; E - 15 - 343 
    ; E - 15 - 346
    ; E - 15 - 356
     
     processor     16f877a
     #include      <p16f877a.inc>
     #include "p16f877a.inc"

; CONFIG
; __config 0xFF31
     __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
    
        org 0x00
        goto Main
	
    
        
             cout1  EQU   23h
	     cout2  EQU   24h
	     cout3  EQU   25h
	     cout4  EQU   26h
	     cout5  EQU   27h
	     cout6  EQU   28h
             cout7  EQU   29h
             cout8  EQU   30h
             cout9  EQU   31h 
             cout10 EQU   32h
             cout11 EQU   33h
             cout12 EQU   34h
 
Main: ;port arrangement and bit allocations
    
        ;select bank 1
      bcf          STATUS,6 
      bsf          STATUS,5  
    
      movlw        b'00000000'
      movwf        TRISD   ;make D as a OP
      
      movlw        b'000'
      movwf        TRISE   ; make E as OP
      
      movlw        b'11111111'
      movwf        TRISB   ;make B as IP
      
      movlw        b'11111111'
      movf         TRISC ;make C as IP
      ;switch to bank 0
      bcf          STATUS,5  
      
    ;------------------------------------------------------    
      
      goto         LANE1
  
LANE1:
     ;move to bank 0
      bcf          STATUS,6
      bcf          STATUS,5
      
      btfss        PORTB,3
      goto         heavy_L1
      btfss        PORTB,2
      goto         less_heavy_L1
      btfss        PORTB,1
      goto         modearte_L1
      btfss        PORTB,0
      goto         low_L1
      
      
LANE2:
    
      btfss        PORTC,0
      goto         heavy_L2
      btfss        PORTB,7
      goto         less_heavy_L2
      btfss        PORTB,6
      goto         moderate_L2
      btfss        PORTB,5
      goto         low_L2

      
LANE3:
      btfss        PORTC,5
      goto         heavy_L3
      btfss        PORTC,4
      goto         less_heavy_L3
      btfss        PORTC,3
      goto         moderate_L3
      btfss        PORTC,2
      goto         low_L3
      
    
      
heavy_L1: ;heavy traffic on lane 1
      movlw        b'01001001' ;red 1,2,3 ==D0-D3-D6**
      movwf        PORTD
      
      bcf           PORTE,2 ;switch off green3
            
      call switch_delay
      
      movlw        b'01001010' ;yellow 1 & red 2 & red 3 ==D1-D3-D6
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01001100' ;green 1 & red 2 & red 3 ==D2-D3-D6
      movwf        PORTD
    
      call   delay_largest ;largest delay
    
      goto              LANE2
    
    
less_heavy_L1: ; much less heavy traffic on lane 1 
      movlw        b'01001001' ;red 1,2,3== 
      movwf        PORTD ;D0-D3-D6
      
      bcf          PORTE,2 ;switch off green3
            
      call switch_delay
      
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD ;D1-D3-D6
      
      call switch_delay
      
      movlw        b'01001100' ;green 1 & red 2 & red 3
      movwf        PORTD;D2-D3-D6
    
      call   delay_2_largest ; 2 nd largest delay
    
      goto              LANE2
    
modearte_L1:
      movlw        b'01001001' ;red 1,2,3
      movwf        PORTD;D0-D3-D6
      
      bcf           PORTE,2 ;switch off green3
            
      call switch_delay
      
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD;D1-D3-D6
      
      call switch_delay
      
      movlw        b'01001100' ;green 1 & red 2 & red 3
      movwf        PORTD;D2-D3-D6
    
      call   delay_3_largest ; 3rd largest delay
   
      goto              LANE2

low_L1:
      movlw        b'01001001' ;red 1,2,3
      movwf        PORTD;D0-D3-D6
      
      bcf           PORTE,2 ;switch off green3
            
      call switch_delay
      
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD;D0-D3-D6
      
      call switch_delay
      
      movlw        b'01001100' ;green 1 & red 2 & red 3
      movwf        PORTD
    
      call   delay_lowest ; lowest delay
    
      goto              LANE2
    

;Lane 2 traffic light pattern    
heavy_L2:
          
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD
      
      bcf          PORTE,2 
      
      call         switch_delay
      
      movlw        b'01001001';red 2 & red 1 & red 3
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01010001' ;yellow 2 & red1 &red 3
      movwf        PORTD
      
      bcf          PORTE,2
      
      call switch_delay
      
      movlw        b'01100001' ;green 2 & red 1 & red 3
      movwf        PORTD
      bcf          PORTE,2
    
      call   delay_largest  ; largest delay
    
      goto              LANE3
    
    
less_heavy_L2:
          
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD
      
      bcf          PORTE,2 
      
      call         switch_delay
      
      movlw        b'01001001';red 2 & red 1 & red 3
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01010001' ;yellow 2 & red1 &red 3
      movwf        PORTD
      
      bcf          PORTE,2
      
      call switch_delay
      
      movlw        b'01100001' ;green 2 & red 1 & red 3
      movwf        PORTD
      bcf          PORTE,2
      
      call   delay_2_largest  ; 2 nd largest delay
    
      goto              LANE3
    
moderate_L2:
          
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD
      
      bcf          PORTE,2 
      
      call         switch_delay
      
      movlw        b'01001001';red 2 & red 1 & red 3
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01010001' ;yellow 2 & red1 &red 3
      movwf        PORTD
      
      bcf          PORTE,2
      
      call switch_delay
      
      movlw        b'01100001' ;green 2 & red 1 & red 3
      movwf        PORTD
      bcf          PORTE,2
      
      call   delay_3_largest  ;3 rd largest delay
    
      goto              LANE3

low_L2:
          
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD
      
      bcf          PORTE,2 
      
      call         switch_delay
      
      movlw        b'01001001';red 2 & red 1 & red 3
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01010001' ;yellow 2 & red1 &red 3
      movwf        PORTD
      
      bcf          PORTE,2
      
      call switch_delay
      
      movlw        b'01100001' ;green 2 & red 1 & red 3
      movwf        PORTD
      bcf          PORTE,2
      
      call   delay_lowest  ; lowest delay
    
      goto              LANE3

;lane 3 traffic light patterns    
heavy_L3:
      movlw        b'01010001' ;yellow 2 & red 1 & red 3
      movwf        PORTD
     
      bcf          PORTE,2
      call switch_delay
                  
      movlw         b'01001001' ; red 3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2
      
      call switch_delay
      
      movlw         b'10001001' ; yellow3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2      
   
      call switch_delay
      
      movlw         b'00001001'; red 2, red 1   
      movwf         PORTD
 
      bsf           PORTE,2 ; green 3
      
      call   delay_largest  ; largest delay
    
      goto              LANE1
    
    
less_heavy_L3:
      movlw        b'01010001' ;yellow 2 & red 1 & red 3
      movwf        PORTD
     
      bcf          PORTE,2
      call switch_delay
                  
      movlw         b'01001001' ; red 3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2
      
      call switch_delay
      
      movlw         b'10001001' ; yellow3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2      
   
      call switch_delay
      
      movlw         b'00001001'; red 2, red 1   
      movwf         PORTD
 
      bsf           PORTE,2 ; green 3
      
      call   delay_2_largest  ; 2 nd largest delay
    
      goto              LANE1
    
moderate_L3:
      movlw        b'01010001' ;yellow 2 & red 1 & red 3
      movwf        PORTD
     
      bcf          PORTE,2
      call switch_delay
                  
      movlw         b'01001001' ; red 3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2
      
      call switch_delay
      
      movlw         b'10001001' ; yellow3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2      
   
      call switch_delay
      
      movlw         b'00001001'; red 2, red 1   
      movwf         PORTD
 
      bsf           PORTE,2 ; green 3
      
      call   delay_3_largest  ; 3 rd largest delay
    
      goto              LANE1

low_L3:
      movlw        b'01010001' ;yellow 2 & red 1 & red 3
      movwf        PORTD
     
      bcf          PORTE,2
      call switch_delay
                  
      movlw         b'01001001' ; red 3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2
      
      call switch_delay
      
      movlw         b'10001001' ; yellow3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2      
   
      call switch_delay
      
      movlw         b'00001001'; red 2, red 1   
      movwf         PORTD
 
      bsf           PORTE,2 ; green 3
      
      call   delay_lowest  ; lowest delay
    
      goto              LANE1    


      
;lane 1 lighting pattern      
PATTERN1:      

      
      movlw        b'01001001' ;red 1,2,3
      movwf        PORTD
      
      bcf           PORTE,2 ;switch off green3
            
      call switch_delay
      
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01001100' ;green 1 & red 2 & red 3
      movwf        PORTD
      
      
       
     
     
PATTERN2:
      
      movlw        b'01001010' ;yellow 1 & red 2 & red 3
      movwf        PORTD
      
      bcf          PORTE,2 
      
      call         switch_delay
      
      movlw        b'01001001';red 2 & red 1 & red 3
      movwf        PORTD
      
      call switch_delay
      
      movlw        b'01010001' ;yellow 2 & red1 &red 3
      movwf        PORTD
      
      bcf          PORTE,2
      
      call switch_delay
      
      movlw        b'01100001' ;green 2 & red 1 & red 3
      movwf        PORTD
      bcf          PORTE,2
      
      
      
      
PATTERN3:
          
      movlw        b'01010001' ;yellow 2 & red 1 & red 3
      movwf        PORTD
     
      bcf          PORTE,2
      call switch_delay
                  
      movlw         b'01001001' ; red 3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2
      
      call switch_delay
      
      movlw         b'10001001' ; yellow3 & red 1 & red 2
      movwf         PORTD
      
      bcf           PORTE,2      
   
      call switch_delay
      
      movlw         b'00001001'; red 2, red 1   
      movwf         PORTD
 
      bsf           PORTE,2 ; green 3
      
      
      
delay_largest: ; 20s
      movlw        d'100'
      movwf        cout1
      
      movlw        d'120'
      movwf        cout2
      
      movlw        d'20'
      movwf        cout3
    
     loop1 decfsz cout1,1
     goto loop1
     
     decfsz cout2,1
     goto loop1
     
     decfsz cout3,1
     goto loop1
     
     return
     
delay_2_largest:
    
      movlw        d'100'
      movwf        cout4
      
      movlw        d'60'
      movwf        cout5
      
      movlw        d'20'
      movwf        cout6
    
     loop2 decfsz cout4,1
     goto loop2
     
     decfsz cout5,1
     goto loop2
     
     decfsz cout6,1
     goto loop2
     
     return
      
delay_3_largest:
    
      movlw        d'60'
      movwf        cout7
      
      movlw        d'60'
      movwf        cout8
      
      movlw        d'10'
      movwf        cout9
    
     loop3 decfsz cout7,1
     goto loop3
     
     decfsz cout8,1
     goto loop3
     
     decfsz cout9,1
     goto loop3
     
     return      
     
delay_lowest:
    
      movlw        d'50'
      movwf        cout10
      
      movlw        d'60'
      movwf        cout11
      
      movlw        d'2'
      movwf        cout12
    
     loop4 decfsz cout10,1
     goto loop4
     
     decfsz cout11,1
     goto loop4
     
     decfsz cout12,1
     goto loop4
     
     return     
     
switch_delay: ;1s for switching lights
    
      movlw        d'100'
      movwf        cout1
      
      movlw        d'60'
      movwf        cout2
    
     loop decfsz cout1,1
     goto loop
     
     decfsz cout2,1
     goto loop
     
     return
     


    
    
end


