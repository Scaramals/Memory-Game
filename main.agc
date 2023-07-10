
// Project: memory_game 
// Created: 2023-05-11

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "memory_game" )
SetWindowSize( 1920, 1080, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1920, 1080 ) // doesn't have to match the window
MaximizeWindow()
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//fundo do jogo
CreateSprite(LoadImage("teladojogo.png"))

//carrega as imagens
LoadImage(1,"piano.png")
LoadImage(2,"maracas.png")
LoadImage(3,"sanfona.png")
LoadImage(4,"saxofone.png")
LoadImage(5,"tamborim.png")
LoadImage(6,"teclado.png")
LoadImage(7,"triangulo.png")
LoadImage(8,"violino.png")
LoadImage(9,"clave.png")
LoadImage(10,"clave.png")
LoadImage(11,"clave.png")
LoadImage(12,"clave.png")
LoadImage(13,"clave.png")
LoadImage(14,"clave.png")
LoadImage(15,"clave.png")
LoadImage(16,"clave.png")
LoadImage(17,"clave.png")
LoadImage(18,"clave.png")
LoadImage(19,"clave.png")
LoadImage(20,"clave.png")
LoadImage(21,"clave.png")
LoadImage(22,"clave.png")
LoadImage(23,"clave.png")
LoadImage(24,"clave.png")

LoadImage(25,"menu.png")
LoadImage(26,"endgame.png")

//musicaMenu = LoadMusic("musicadomenu.wav")
//PlayMusic(musicaMenu,1)

musicaEndGame = LoadMusic("aplausos.wav")

dim instrumentos[4,4] //matriz dos instrumentos que recebe as sprites

instrumentos[0,0] = CreateSprite(1)
instrumentos[0,1] = CreateSprite(2)
instrumentos[0,2] = CreateSprite(3)
instrumentos[0,3] = CreateSprite(4)
instrumentos[1,0] = CreateSprite(5)
instrumentos[1,1] = CreateSprite(6)
instrumentos[1,2] = CreateSprite(7)
instrumentos[1,3] = CreateSprite(8)

instrumentos[2,0] = CreateSprite(1)
instrumentos[2,1] = CreateSprite(2)
instrumentos[2,2] = CreateSprite(3)
instrumentos[2,3] = CreateSprite(4)
instrumentos[3,0] = CreateSprite(5)
instrumentos[3,1] = CreateSprite(6)
instrumentos[3,2] = CreateSprite(7)
instrumentos[3,3] = CreateSprite(8)

dim clave[4,4] //matriz das claves

clave[0,0] = CreateSprite(9)
clave[0,1] = CreateSprite(10)
clave[0,2] = CreateSprite(11)
clave[0,3] = CreateSprite(12)
clave[1,0] = CreateSprite(13)
clave[1,1] = CreateSprite(14)
clave[1,2] = CreateSprite(15)
clave[1,3] = CreateSprite(16)

clave[2,0] = CreateSprite(17)
clave[2,1] = CreateSprite(18)
clave[2,2] = CreateSprite(19)
clave[2,3] = CreateSprite(20)
clave[3,0] = CreateSprite(21)
clave[3,1] = CreateSprite(22)
clave[3,2] = CreateSprite(23)
clave[3,3] = CreateSprite(24)

menu = CreateSprite(25)
endgame = CreateSprite(26)
SetSpriteVisible(endgame,0)

dim gabarito[4,4] //matriz que recebe os ids dos intrumentos

gosub embaralhaCarta
gosub posicionaCartas
gosub pegaid




//variaveis

escolha1 = 0
escolha2 = 0

claveclicada1 = 0 //clave que esta sobre a escolha 1
claveclicada2 =0 //clave que esta sobre a escolha 2

besttime = 0

clique = 0

pausa = 15 //variavel para armazenar o tempo que a carta vai ficar virada para cima

acertos = 0

gameRunning = 0 // Flag para indicar se o jogo está em execução ou se o menu está sendo exibido
menuVisible = 1 // Flag para indicar se o menu deve ser desenhado na tela

recorde = 0


//o jogo tem uma tela de inicio que tem um botao de opções de e do manual e mutar a musica de fundo

//o record de tempo maximo sera guardado em cada dificuldade (recordFacil...)

//uma sera o jogo e outra que estara com os valores zerados


do
    
    If gameRunning = 0 //menu
        // Exibir menu
        If menuVisible = 1

            DrawSprite(menu)
        EndIf

     // Esperar pela tecla 'Enter' para iniciar o jogo e começar o contador de tempo
        If GetRawKeyPressed(13) // 13 é o código da tecla 'Enter'
            gameRunning = 1 // Iniciar o jogo
            menuVisible = 0 // Ocultar o menu
            ResetTimer()
			SetSpriteVisible(menu,0) // Apagar o sprite do menu
			

        EndIf
    
	endif
	
    if gameRunning = 1 //jogo rodando
		if acertos<8
			time = timer()
			Print("                                               Tempo: " + str(time)+ "   Recorde Atual: " + str(recorde))
		endif
		
		for i = 0 to 3
			for j = 0 to 3
				SetSpriteVisible(instrumentos[i,j],1)
			next j
		next i
	//funcao para pegar o clique do mouse 
		if(GetPointerPressed() = 1)
		
			for i = 0 to 3
				for j = 0 to 3
					mouseX# = GetPointerX()
					mouseY# = GetPointerY()
					if (GetSpriteInBox (clave[i,j], mouseX#, mouseY#, mouseX#, mouseY#) and GetSpriteVisible(clave[i,j])) //verifica se a clave esta invisivel e a sprite que ele clicou
						
						if (clique = 0) 
							escolha1 = clave[i,j]
							claveclicada1 = gabarito[i,j]
							clique = 1
						elseif(clique = 1)
							escolha2 = clave[i,j]
							claveclicada2 = gabarito[i,j]
							clique = 2
							
						endif
					endif
					
				 next j
			 next i
			 
		endif
		
		
	//funcao que compara as claves viradas
		if(clique = 2)
			pausa = pausa - 1 
			if(pausa = 0)
				if(claveclicada1 = claveclicada2)
					if(GetSpriteExists(escolha1) = 1)
						SetSpriteVisible(escolha1,0)
				
					endif
			
					if(GetSpriteExists(escolha2) = 1)
						SetSpriteVisible(escolha2,0)
				
					endif
					
					acertos = acertos + 1 
					
				else
					if(GetSpriteExists(escolha1) = 1)
						
						SetSpriteVisible(escolha1,1)
						
					endif
					
					if(GetSpriteExists(escolha2) = 1)
					
						SetSpriteVisible(escolha2,1)
						
					endif
					escolha1 = 0
					escolha2 = 0
				endif
				clique = 0
				pausa = 15
				
			endif
		
		endif

		
	 //funcao para deixar as cartas invisiveis
		if(GetSpriteExists(escolha1) = 1)
			SetSpriteVisible(escolha1,0)
			
		endif
		
		if(GetSpriteExists(escolha2) = 1)
			SetSpriteVisible(escolha2,0)
			
		endif

		if(acertos = 8)
			if GetSpriteVisible(endgame) = 0
				StopMusic()
				//PlayMusic(musicaEndGame,1)
			endif
			
			for i = 0 to 3
				for j = 0 to 3
					SetSpriteVisible(instrumentos[i,j],0)
				next j
			next i
			
			SetSpriteVisible(endgame,1) //tela do fim do jogo
			
			if recorde = 0 or time<recorde //armazena o recorde
				recorde = time
			endif 
			Print("")
			Print("")
			Print("")
			Print("")
			Print("")
			Print("")
			Print("")
			Print("")
			Print("")
			Print("                                               		      		" + str(time))
			Print("")
			Print("                                              		      		" + str(recorde))
			Print("")
			
			 If GetRawKeyPressed(27) // ele volta para o menu
				 
				
				//StopMusic()
				//PlayMusic(musicaMenu,1)
				
				acertos = 0
				gameRunning = 0 // voltar 
				menuVisible = 1 // o menu
				escolha1 = 0
				escolha2 = 0
				claveclicada1 = 0 //clave que esta sobre a escolha 1
				claveclicada2 =0 //clave que esta sobre a escolha 2
				
				gosub embaralhaCarta
				gosub posicionaCartas
				gosub pegaid
				
				SetSpriteVisible(endgame,0)
				SetSpriteVisible(menu,1) // Apagar o sprite do menu
				
				for i = 0 to 3
					for j = 0 to 3
						SetSpriteVisible(clave[i,j],1)
					next j
				next i
				
				
			EndIf
		endif
	endif

		Sync()
loop
embaralhaCarta:		
	for i = 0 to 3 //atribui os enderecos a posicao dos instrumentos
		
		for j = 0 to 3
			randi = Random(0,3)
			randj = Random(0,3)
			temp = instrumentos[i,j]
			instrumentos[i,j] = instrumentos[randi,randj]
			instrumentos[randi,randj] = temp
		next j
	next i
return

posicionaCartas:
	for i = 0 to 3 //posiciona as cartas depois os instrumentos por cima
			
		for j = 0 to 3
			SetSpritePosition(instrumentos[i,j],600+180*i,200+ 180*j)
			SetSpritePosition(clave[i,j],600+180*i,200+ 180*j)
		next j
	next i
return

pegaid:
	for i = 0 to 3
		for j = 0 to 3
			gabarito[i,j] = GetSpriteImageID(instrumentos[i,j])
		next j
	next i
return
