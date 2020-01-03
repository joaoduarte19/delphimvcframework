unit MVCFramework.OpenAPI;

interface

uses
  System.Generics.Collections;

type
  /// <summary>
  /// <para>
  /// <see href="https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#infoObject">Info
  /// Object</see>
  /// </para>
  /// <para>
  /// The object provides metadata about the API. The metadata MAY be used by the clients if needed, and MAY be
  /// presented in editing or documentation generation tools for convenience.
  /// </para>
  /// </summary>
  TOpenApiInfo = class
  private type
    TContact = class
    private
      fName: string;
      fEMail: string;
      fURL: string;
    public
      property Name: string read fName write fName;
      property URL: string read fURL write fURL;
      property EMail: string read fEMail write fEMail;
    end;

    TLicense = class
    private
      fName: string;
      fURL: string;
    public
      property Name: string read fName write fName;
      property URL: string read fURL write fURL;
    end;

  private
    fVersion: string;
    fTitle: string;
    fDescription: string;
    fTermsOfService: string;
    fContact: TContact;
    fLicense: TLicense;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// <b>REQUIRED</b>. The title of the application.
    /// </summary>
    property Title: string read fTitle write fTitle;

    /// <summary>
    /// A short description of the application. CommonMark syntax may be used for rich text representation.
    /// </summary>
    property Description: string read fDescription write fDescription;

    /// <summary>
    /// A URL to the Terms of Service for the API. MUST be in the format of a URL.
    /// </summary>
    property TermsOfService: string read fTermsOfService write fTermsOfService;

    /// <summary>
    /// The contact information for the exposed API.
    /// </summary>
    property Contact: TContact read fContact write fContact;

    /// <summary>
    /// The license information for the exposed API.
    /// </summary>
    property License: TLicense read fLicense write fLicense;

    /// <summary>
    /// <b>REQUIRED</b>. The version of the OpenAPI document (which is distinct from the OpenAPI Specification
    /// version or the API implementation version).
    /// </summary>
    property Version: string read fVersion write fVersion;
  end;

  /// <summary>
  /// Allows referencing an external resource for extended documentation
  /// </summary>
  TOpenAPIExternalDoc = class
  private
    fDescription: string;
    fURL: string;
  public

    /// <summary>
    /// A short description of the target documentation. CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: string read fDescription write fDescription;

    /// <summary>
    /// <b>REQUIRED</b>. The URL for the target documentation. Value MUST be in the format of a URL.
    /// </summary>
    property URL: string read fURL write fURL;
  end;

/// <summary>
  /// <para>
  /// <see href="https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#serverVariableObject">
  /// Server Variable Object</see>
  /// </para>
  /// <para>
  /// An object representing a Server Variable for server URL template substitution.
  /// </para>
  /// </summary>
  TOpenAPIServerVariable = class
  private
    fEnum: TList<string>;
    fDescription: string;
    fDefault: string;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// An enumeration of string values to be used if the substitution options are from a limited set.
    /// </summary>
    property Enum: TList<string> read fEnum write fEnum;

    /// <summary>
    /// <b>REQUIRED</b>. The default value to use for substitution, and to send, if an alternate value is not
    /// supplied. Unlike the Schema Object's default, this value MUST be provided by the consumer.
    /// </summary>
    property &Default: string read fDefault write fDefault;

    /// <summary>
    /// An optional description for the server variable. CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: string read fDescription write fDescription;
  end;

  /// <summary>
  /// <para>
  /// <see href="https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#serverObject">Server
  /// Object</see>
  /// </para>
  /// <para>
  /// An object representing a Server.
  /// </para>
  /// </summary>
  TOpenAPIServer = class
  private
    fURL: string;
    fDescription: string;
    fVariables: TObjectDictionary<string, TOpenAPIServerVariable>;
  public
    constructor Create;
    destructor Destroy; override;

    property URL: string read fURL write fURL;
    property Description: string read fDescription write fDescription;
    property Variables: TObjectDictionary<string, TOpenAPIServerVariable> read fVariables write fVariables;
  end;

  TOpenAPIOperation = class

  end;

  TOpenAPIParameter = class

  end;

  /// <summary>
  /// <para>
  /// <see href="https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#pathItemObject">Path
  /// Item Object</see>
  /// </para>
  /// <para>
  /// Describes the operations available on a single path. A Path Item MAY be empty, due to ACL constraints. The
  /// path itself is still exposed to the documentation viewer but they will not know which operations and
  /// parameters are available.
  /// </para>
  /// </summary>
  TOpenAPIPathItem = class
  private
    fSummary: string;
    fDescription: string;
    fOperations: TObjectDictionary<string, TOpenAPIOperation>;
    fServers: TObjectDictionary<string, TOpenAPIServer>;
    fParameters: TObjectDictionary<string, TOpenAPIParameter>;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// An optional, string summary, intended to apply to all operations in this path.
    /// </summary>
    property Summary: string read fSummary write fSummary;

    /// <summary>
    /// An optional, string description, intended to apply to all operations in this path. CommonMark syntax MAY be
    /// used for rich text representation.
    /// </summary>
    property Description: string read fDescription write fDescription;

    /// <summary>
    /// Operations defined for this path
    /// </summary>
    property Operations: TObjectDictionary<string, TOpenAPIOperation> read fOperations write fOperations;

    /// <summary>
    /// An alternative server array to service all operations in this path.
    /// </summary>
    property Servers: TObjectDictionary<string, TOpenAPIServer> read fServers write fServers;

    /// <summary>
    /// A list of parameters that are applicable for all the operations described under this path. These parameters
    /// can be overridden at the operation level, but cannot be removed there.
    /// </summary>
    property Parameters: TObjectDictionary<string, TOpenAPIParameter> read fParameters write fParameters;

  end;

// TOpenAPIDocument = class
// private
// fOpenAPI: string;
// fInfo: TOpenAPIInfo;
// fServers: TObjectList<TOpenAPIServer>;
// public
// constructor Create;
// destructor Destroy; override;
//
// property OpenAPI: string read fOpenAPI write fOpenAPI;
// property Info: TOpenAPIInfo read fInfo write fInfo;
// property Servers: TObjectList<TOpenAPIServer> read fServers write fServers;
// end;

implementation

{ TOpenApiInfo }

constructor TOpenApiInfo.Create;
begin
  inherited Create;
  fContact := TContact.Create;
  fLicense := TLicense.Create;
end;

destructor TOpenApiInfo.Destroy;
begin
  fLicense.Free;
  fContact.Free;
  inherited Destroy;
end;

{ TOpenAPIServer }

constructor TOpenAPIServer.Create;
begin
  inherited Create;
  fVariables := TObjectDictionary<string, TOpenAPIServerVariable>.Create([doOwnsValues]);
end;

destructor TOpenAPIServer.Destroy;
begin
  fVariables.Free;
  inherited Destroy;
end;

{ TOpenAPIServerVariable }

constructor TOpenAPIServerVariable.Create;
begin
  inherited Create;
  fEnum := TList<string>.Create;
end;

destructor TOpenAPIServerVariable.Destroy;
begin
  fEnum.Free;
  inherited Destroy;
end;

{ TOpenAPIPathItem }

constructor TOpenAPIPathItem.Create;
begin
  inherited Create;
  fOperations := TObjectDictionary<string, TOpenAPIOperation>.Create([doOwnsValues]);
  fServers := TObjectDictionary<string, TOpenAPIServer>.Create([doOwnsValues]);
  fParameters := TObjectDictionary<string, TOpenAPIParameter>.Create([doOwnsValues]);
end;

destructor TOpenAPIPathItem.Destroy;
begin
  fParameters.Free;
  fServers.Free;
  fOperations.Free;
  inherited Destroy;
end;

end.
