unit Mb.Constants;

interface

const
  MbDefaultPort: integer = 2525;
  DefaultPort: integer = 4545;

  DefaultProtocol: string = 'http';


  type
  MbUrls = class
  public
    const
      BaseUrl = 'http://127.0.0.1:%d';
      ImpostersUrl = BaseUrl + '/imposters';
      DeleteSingleImposterUrl = BaseUrl + '/imposters/%d';
  end;

  HttpStatusCode = class
  public
    const
    OK: integer = 200;
    Created: Integer = 201;
end;

implementation

end.
