@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '-'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

define view entity Z13_C_EMPLOYEEQUERY
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
      
      
      @Semantics.amount.currencyCode: 'currencyCodeUSD'
      @EndUserText.label: 'Annual Salary'
      cast(AnnualSallary as abap.fltp) / 12.0 as  MonthlySalary,
      //CurrencyCode,
      cast('USD' as /dmo/currency_code) as CurrencyCodeUSD,
     
     @EndUserText.label: 'Monthly salary'
     @EndUserText.quickInfo: 'Monthly salary'
      // date functions : dats_days_between
      division(dats_days_between( EntryDate,$session.system_date),365,1) as CompanyAffiliation,
      
      @EndUserText.label: 'Annual Salary'
      @EndUserText.quickInfo: 'Annual Salary'
      @Semantics.amount.currencyCode: 'CurrencyCodeUSD'
      currency_conversion(
        amount => AnnualSallary,
        source_currency => CurrencyCode,
        target_currency => $projection.CurrencyCodeUSD,
        exchange_rate_date => $session.system_date )                                          as AnnualSalaryConverted,
      
      /* Associations */
      _Department
}
