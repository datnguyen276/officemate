*** Setting ***
Resource    ${CURDIR}/../../../Libs/libs.robot
*** Variable ***
${GLOBALTIMEOUT}    ${30}
*** Keywords ***
Open Browser To Page
    [Arguments]                                ${url}               ${speed}=0.1
    ${options}=                                Evaluate             sys.modules['selenium.webdriver'].ChromeOptions()    sys
    ${exclude}=                                Create Dictionary    "fasp"=True
    ${prefs}=                                  Create Dictionary    protocol_handler.excluded_schemes=${exclude}
    Call Method                                ${options}           add_argument                                         --disable-infobars
    Call Method                                ${options}           add_argument                                         --disable-notifications
    Call Method                                ${options}           add_experimental_option                              prefs                      ${prefs}
    SeleniumLibrary.Create WebDriver           Chrome               chrome_options=${options}    executable_path=${CURDIR}/../../../chromedriver.exe
    SeleniumLibrary.Maximize Browser Window
    SeleniumLibrary.Set Selenium Speed         ${speed}
    SeleniumLibrary.Go To                      ${url}

Click Element
    [Arguments]                                      ${locator}    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    SeleniumLibrary.Click Element                    ${locator}

Wait To Element Visible
    [Arguments]                                         ${locator}
    SeleniumLibrary.Wait Until Page Contains Element    ${locator}    timeout=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible       ${locator}    timeout=${GLOBALTIMEOUT}

Get Text And Compare Value
    [Arguments]                       ${locator}                      ${text_value}
    ${text}                           Get Text Element                ${locator}
    BuiltIn.Return From Keyword If
    ...                               '${text}' == '${text_value}'    ${true}

Input Data And Verify Text For Web Element
    [Arguments]                   ${locator}                   ${expect_text}
    SeleniumLibrary.Input Text    ${locator}                   ${expect_text}
    ${real_text}=                 SeleniumLibrary.Get Value    ${locator}
    Should Be Equal               '${real_text}'               '${expect_text}'

Input Data
    [Arguments]                   ${locator}    ${value}
    SeleniumLibrary.Input Text    ${locator}    ${value}

Close Popup If It Appeared
    [Arguments]                            ${elmement1}                                 ${element2}
    Run Keyword And Ignore Error           SeleniumLibrary.Element Should Be Visible    ${element1}
    BuiltIn.Wait Until Keyword Succeeds    3 x                                          1 sec          Common_Keywords.Clicck Element    ${element2}

Verify Contains Text In List
    [Arguments]                                    ${element}                         ${value}
    ${listElement}=                                SeleniumLibrary.Get WebElements    ${element}
    FOR                                            ${item}                            IN            @{listElement}
    ${text}=                                       SeleniumLibrary.Get Text           ${item}
    SeleniumLibrary.Wait Until Element Contains    ${item}                            ${value}      ${GLOBALTIMEOUT}
    END