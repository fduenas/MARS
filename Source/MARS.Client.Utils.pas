(*
  Copyright 2016, MARS-Curiosity library

  Home: https://github.com/andrea-magni/MARS
*)
unit MARS.Client.Utils;

interface

uses
  Classes, SysUtils
  ;

type
  EMARSClientException = class(Exception);
  EMARSClientHttpException = class(EMARSClientException)
  private
    FStatusText: string;
    FStatusCode: Integer;
  public
    constructor Create(const AStatusText: string; const AStatusCode: Integer = 500); virtual;

    property StatusText: string read FStatusText;
    property StatusCode: Integer read FStatusCode;
  end;

  TMARSClientProc = TProc;
  TMARSClientResponseProc = TProc<TStream>;
  TMARSClientExecptionProc = TProc<Exception>;

  TMARSComponentHelper = class
  public
    class function IsDesigning(AComponent: TComponent): Boolean;
    class function FindDefault<T: class>(AComponent: TComponent): T;
  end;


implementation

class function TMARSComponentHelper.IsDesigning(AComponent: TComponent): Boolean;
begin
  Result :=
    ([csDesigning, csLoading] * AComponent.ComponentState = [csDesigning]) and
    ((AComponent.Owner = nil) or
     ([csDesigning, csLoading] * AComponent.Owner.ComponentState = [csDesigning]));
end;

class function TMARSComponentHelper.FindDefault<T>(AComponent: TComponent): T;
var
  LRoot: TComponent;
  LIndex: Integer;
begin
  Result := nil;
  LRoot := AComponent;
  while (LRoot.Owner <> nil) and (Result = nil) do begin
    LRoot := LRoot.Owner;
    for LIndex := 0 to LRoot.ComponentCount - 1 do
      if LRoot.Components[LIndex] is T then begin
        Result := T(LRoot.Components[LIndex]);
        Break;
      end;
  end;
end;


{ EMARSClientHttpException }

constructor EMARSClientHttpException.Create(const AStatusText: string;
  const AStatusCode: Integer);
begin
  inherited Create(AStatusCode.ToString + ': ' + AStatusText);
  FStatusCode := AStatusCode;
  FStatusText := AStatusText;
end;

end.
