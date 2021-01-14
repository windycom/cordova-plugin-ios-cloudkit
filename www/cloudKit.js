var exec = require("cordova/exec");

exports.init = function (cloudId, recordType, success, error) {
  exec(success, error, "cloudKit", "initialize", [cloudId, recordType]);
};

exports.set = function (key, value, success, error) {
  exec(success, error, "cloudKit", "set", [key, value]);
};

exports.get = function (key, success, error) {
  exec(success, error, "cloudKit", "get", [key]);
};

exports.delete = function (key, success, error) {
  exec(success, error, "cloudKit", "delete", [key]);
};
