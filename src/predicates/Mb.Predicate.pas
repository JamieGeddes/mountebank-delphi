unit Mb.Predicate;

interface

uses
  superobject;

type
  TMbPredicate = class
  protected
    FCaseSensitive: Boolean;
    FExcept: string;
//    FXpath: string;
//    FJsonPath: string;
  public
    procedure PopulateRequestBody(const requestBody: ISuperObject); virtual; abstract;
  end;

implementation

end.
