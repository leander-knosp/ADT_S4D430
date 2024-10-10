@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '-'
@Metadata.ignorePropagatedAnnotations: false

define view entity Z13_C_EmployeeQueryP
  with parameters
    P_TargetCurrencyCode : /dmo/currency_code,
    @EndUserText.label: 'Date of Evaluation'
    @EndUserText.quickInfo: 'Date of Evaluation'
    P_DateOfEvaluation   : abap.dats
  as select from Z13_R_EMPLYEE
{
  key EmployeeId,
      FirstName,
      LastName,
      DepartmentID,
      _Department.Description as DepartmentDescription, 
     
     // String function: concatinate with space
     concat_with_space(_Department._Assistant.FirstName,_Department._Assistant.LastName,1 ) as AssistantName,
     
      
      @EndUserText.label: 'Employee Role'
      case EmployeeId 
      when _Department.HeadId  then 'H' 
      when _Department.AssistantId then 'A'
       else ''  end as EmployeeRole,
      
      
      @EndUserText.label: 'Monthly Salary'
      @EndUserText.quickInfo: 'Monthly Salary'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      cast($projection.AnnualSalaryConverted as abap.fltp) / 12.0                             as MonthlySalaryConverted,

      $parameters.P_TargetCurrencyCode                                                        as CurrencyCode,
      @EndUserText.label: 'Company Affiliation'
      @EndUserText.quickInfo: 'Company Affiliation'
      division(dats_days_between(EntryDate, $parameters.P_DateOfEvaluation), 365, 1)          as CompanyAffiliation,
      
      @EndUserText.label: 'Annual Salary'
      @EndUserText.quickInfo: 'Annual Salary'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      currency_conversion(
        amount => AnnualSallary,
        source_currency => CurrencyCode,
        target_currency => $parameters.P_TargetCurrencyCode,
        exchange_rate_date => $parameters.P_DateOfEvaluation,
        error_handling => 'SET_TO_NULL' )                                         as AnnualSalaryConverted,
      
      /* Associations */
      _Department
}
