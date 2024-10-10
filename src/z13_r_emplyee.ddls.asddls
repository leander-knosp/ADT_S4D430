@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '-'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity Z13_R_EMPLYEE 
  as select from /lrn/employ_dep
  association [1..1] to Z14_R_DEPARTMENT as _Department 
  on $projection.DepartmentID = _Department.Id
{
  key employee_id           as EmployeeId,
      first_name            as FirstName,
      last_name             as LastName,
      birth_date            as BirthDate,
      entry_date            as EntryDate,
      department_id         as DepartmentID,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      annual_salary        as AnnualSallary,
      @EndUserText.label: 'Currency Key'
      currency_code         as CurrencyCode,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,
      
      _Department
}
