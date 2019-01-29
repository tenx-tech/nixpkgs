{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, text-unidecode, ipaddress ? null,
  # Test inputs
  email_validator, mock, ukpostcodeparser, pytestrunner, pytest}:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v1pjzn9z20ckgv3kji7c8nwcsm7670z4i43ic9skjrdbcqylwfq";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [
    email_validator
    mock
    ukpostcodeparser
    pytest
  ];

  propagatedBuildInputs = [
    dateutil
    six
    text-unidecode
  ] ++ lib.optional (pythonOlder "3.3") ipaddress;

  postPatch = ''
    find tests -type d -name "__pycache__" | xargs rm -r
    substituteInPlace setup.py --replace "pytest>=3.8.0,<3.9" "pytest"
  '';

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
