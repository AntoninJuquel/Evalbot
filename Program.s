		AREA    |.text|, CODE, READONLY
		ENTRY
		EXPORT	__main
		
		IMPORT LED_INIT 				
		IMPORT ALLUME_DROITE				
		IMPORT ALLUME_GAUCHE				
		IMPORT ETEINT_DROITE				
		IMPORT ETEINT_GAUCHE				
			
		IMPORT	MOTEUR_INIT					
		
		IMPORT	MOTEUR_DROIT_ON				
		IMPORT  MOTEUR_DROIT_OFF			
		IMPORT  MOTEUR_DROIT_AVANT			
		IMPORT  MOTEUR_DROIT_ARRIERE		
		IMPORT  MOTEUR_DROIT_INVERSE		
		
		IMPORT	MOTEUR_GAUCHE_ON			
		IMPORT  MOTEUR_GAUCHE_OFF			
		IMPORT  MOTEUR_GAUCHE_AVANT			
		IMPORT  MOTEUR_GAUCHE_ARRIERE		
		IMPORT  MOTEUR_GAUCHE_INVERSE		
			
		
		IMPORT	SWITCH_INIT
		IMPORT	BUMPER_INIT


__main	
		BL  LED_INIT
		BL 	SWITCH_INIT
		BL	BUMPER_INIT
		BL	MOTEUR_INIT	   

READ_SWITCH_1
		ldr r11,[r7]
		CMP r11,#0x00
		BEQ EXPLORE
		
		ldr r11,[r10]
		CMP r11,#0x00
		BEQ COUNT
		
		BL READ_SWITCH_1
		
READ_SWITCH_2
		ldr r11,[r10]
		CMP r11,#0x00
		BEQ COUNT
		BX LR
		
COUNT
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		
		mov r0, r9
		
COUNT_RIGHT
		CMP	r0, #0x00
        BLE COUNT_LEFT
		
		subs r0, #1
				
		BL 	ALLUME_DROITE
		BL	WAIT
		BL 	ETEINT_DROITE
		BL 	WAIT
		
		BL	COUNT_RIGHT
		
COUNT_LEFT
		mov  r0, r12
left	
		CMP	r0, #0x00
        BLE READ_SWITCH_1
		
		subs r0, #1
		
		BL 	ALLUME_GAUCHE
		BL	WAIT
		BL 	ETEINT_GAUCHE
		BL 	WAIT
		
		BL	left

		
EXPLORE	
		BL MOTEUR_DROIT_ON
		BL MOTEUR_GAUCHE_ON
		BL ETEINT_GAUCHE
		BL ETEINT_DROITE
		ldr r12, =0x00
		ldr r9, =0x00
		
FORWARD		
		BL	MOTEUR_DROIT_AVANT	   
		BL	MOTEUR_GAUCHE_AVANT
		
		BL 	READ_BUMPERS
		BL	READ_SWITCH_2
		
		BL 	FORWARD
		
READ_BUMPERS
		ldr r11,[r5]
		CMP r11,#0x00
		BEQ BUMPER_DROITE
		ldr r11,[r4]
		CMP r11,#0x00
		BEQ BUMPER_GAUCHE 
		BX LR
		
BUMPER_DROITE
		ADD r9, #1
		BL	MOTEUR_DROIT_ARRIERE
		BL	MOTEUR_GAUCHE_ARRIERE
		
		BL 	ETEINT_GAUCHE
		BL 	ETEINT_DROITE
		
		BL  ALLUME_DROITE
		BL	WAIT
		BL 	ETEINT_DROITE
		BL	WAIT
		BL  ALLUME_DROITE
		BL	WAIT
		BL 	ETEINT_DROITE
		
		BL	MOTEUR_GAUCHE_AVANT
		BL	WAIT
				
		BL	FORWARD

BUMPER_GAUCHE
		ADD r12, #1
		BL	MOTEUR_DROIT_ARRIERE
		BL	MOTEUR_GAUCHE_ARRIERE
		
		BL 	ETEINT_GAUCHE
		BL 	ETEINT_DROITE
		
		BL  ALLUME_GAUCHE
		BL	WAIT
		BL 	ETEINT_GAUCHE
		BL	WAIT
		BL  ALLUME_GAUCHE
		BL	WAIT
		BL 	ETEINT_GAUCHE
				
		BL	MOTEUR_DROIT_AVANT
		BL	WAIT
		BL	WAIT
		BL	WAIT
				
		BL	FORWARD
		
WAIT	ldr r1, =0x002FFFFF
wait	subs r1, #1
        bne wait
		BX	LR

		NOP
        END