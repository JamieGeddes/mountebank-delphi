unit Mb.Response;

interface

uses
  superobject;


type
  TMbResponse = class
  public
    procedure PopulateRequestBody(const requestBody: ISuperObject); virtual; abstract;
  end;

implementation

end.
