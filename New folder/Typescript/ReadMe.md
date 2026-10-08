### to run the play write
npx playwright test


## to run particular file
npx playwright test  example.spec.ts

### run with the ui  

npx playwright test  --headed

### to get the logs and report
npx playwright show-report



### to get the ui
npx playwright test   --ui

### report with
npx playwright test --reporter=list



### run in debugmode
npx playwright test --debug

  
 
 ### run chrmium omly
 npx playwright test --project=chromium


### aluri report 
npx allure generate allure-results -o allure-report

### open the report
 npx allure open allure-report







 