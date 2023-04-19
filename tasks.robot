*** Settings ***
Documentation       Tradutor de música da língua raiz para a selecionada.
...                 Salva a letra original e a traduzida em arquivos de texto.

Library            RPA.Browser.Selenium
Library            OperatingSystem
Task Teardown      Close All Browsers

*** Variables ***
${NOME_DA_MUSICA} =    %{NOME_DA_MUSICA=Radioactive}

&{geral}
...    URL=https://www.lyrics.com/lyrics/${NOME_DA_MUSICA}
    


&{page_elements}
...    bestMatches=css:.best-matches a
...    adDimissButton=//div[@id="dismiss-button"]



*** Keywords ***
Pegar Letra
    Open Available Browser        ${geral.URL}
    
    Click Element When Visible    ${page_elements.bestMatches}
    Reload Page
    Click Element When Visible    ${page_elements.bestMatches}
    #Click Element When Visible    ${page_elements.adDimissButton}    
    ${elemento_letra}     Set Variable     //pre[@id="lyric-body-text"]
    ${letra}     Get Text    ${elemento_letra}
    [Return]    ${letra}

Traduzir
    [Arguments]    ${letra}
    Go To    https://translate.google.com.br/?hl=pt-BR&sl=auto&tl=pt&text=${letra}
    ${elemento_traducao}    Set Variable    //div[@class="lRu31"]
    Wait Until Element Is Visible    ${elemento_traducao}
    ${traducao}=    Get Text    ${elemento_traducao}
    [Return]    ${traducao}


Salva letra
    [Arguments]    ${letra}    ${traducao}
    Create File    ${OUTPUT_DIR}${/}original.txt    ${letra}
    Create File    ${OUTPUT_DIR}${/}traduzido.txt   ${traducao}


*** Tasks ***
Traduzir letra original para a língua selecionada
    ${letra}=    Pegar Letra
    ${traducao}=    Traduzir    ${letra}
    Salva letra    ${letra}    ${traducao}
