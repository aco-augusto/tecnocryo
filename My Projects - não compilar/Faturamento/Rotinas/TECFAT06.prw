#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOBJECT.CH" 
#include "TOTVS.CH" 

User Function TECFAT06()     
    
	Local oProdutos := Nil

	oProdutos := TWAmarraProdutos():New()
	oProdutos:CarregaPropiedadeJanela() 
	oProdutos:Show() 
		
Return()