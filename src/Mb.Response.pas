unit Mb.Response;

interface

uses
  superobject;


type
  TMbResponse = class
  public
    procedure AddJson(const json: ISuperObject); virtual; abstract;
  end;

implementation

end.
