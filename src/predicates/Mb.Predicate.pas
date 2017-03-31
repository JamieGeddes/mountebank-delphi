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
    procedure AddJson(const json: ISuperObject); virtual; abstract;
  end;

implementation

end.
