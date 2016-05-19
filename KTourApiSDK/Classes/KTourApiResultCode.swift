//
//  KTourApiResultCode.swift
//  Pods
//
//  Created by Steve Kim on 5/19/16.
//
//

import Foundation

enum KTourApiResultCode: Int {
    case
    NORMAL_CODE = 0,
    APPLICATION_ERROR = 1,
    DB_ERROR = 2,
    NODATA_ERROR = 3,
    HTTP_ERROR = 4,
    SERVICETIMEOUT_ERROR = 5,
    INVALID_REQUEST_PARAMETER_ERROR = 10,
    NO_MANDATORY_REQUEST_PARAMETERS_ERROR = 11,
    NO_OPENAPI_SERVICE_ERROR = 12,
    SERVICE_ACCESS_DENIED_ERROR = 20,
    TEMPORARILY_DISABLE_THE_SERVICEKEY_ERROR = 21,
    LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR = 22,
    SERVICE_KEY_IS_NOT_REGISTERED_ERROR = 30,
    DEADLINE_HAS_EXPIRED_ERROR = 31,
    UNREGISTERED_IP_ERROR = 32,
    UNSIGNED_CALL_ERROR = 33,
    UNKNOWN_ERROR = 99
}

func KTourApiGetErrorDomain(resultCode: KTourApiResultCode) -> String {
    switch resultCode {
    case KTourApiResultCode.APPLICATION_ERROR:
        return "APPLICATION_ERROR"
    case KTourApiResultCode.DB_ERROR:
        return "DB_ERROR"
    case KTourApiResultCode.NODATA_ERROR:
        return "NODATA_ERROR"
    case KTourApiResultCode.HTTP_ERROR:
        return "HTTP_ERROR"
    case KTourApiResultCode.SERVICETIMEOUT_ERROR:
        return "SERVICETIMEOUT_ERROR"
    case KTourApiResultCode.INVALID_REQUEST_PARAMETER_ERROR:
        return "INVALID_REQUEST_PARAMETER_ERROR"
    case KTourApiResultCode.NO_MANDATORY_REQUEST_PARAMETERS_ERROR:
        return "NO_MANDATORY_REQUEST_PARAMETERS_ERROR"
    case KTourApiResultCode.NO_OPENAPI_SERVICE_ERROR:
        return "NO_OPENAPI_SERVICE_ERROR"
    case KTourApiResultCode.SERVICE_ACCESS_DENIED_ERROR:
        return "SERVICE_ACCESS_DENIED_ERROR"
    case KTourApiResultCode.TEMPORARILY_DISABLE_THE_SERVICEKEY_ERROR:
        return "TEMPORARILY_DISABLE_THE_SERVICEKEY_ERROR"
    case KTourApiResultCode.LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR:
        return "LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR"
    case KTourApiResultCode.SERVICE_KEY_IS_NOT_REGISTERED_ERROR:
        return "SERVICE_KEY_IS_NOT_REGISTERED_ERROR"
    case KTourApiResultCode.DEADLINE_HAS_EXPIRED_ERROR:
        return "DEADLINE_HAS_EXPIRED_ERROR"
    case KTourApiResultCode.UNREGISTERED_IP_ERROR:
        return "UNREGISTERED_IP_ERROR"
    case KTourApiResultCode.UNSIGNED_CALL_ERROR:
        return "UNSIGNED_CALL_ERROR"
    case KTourApiResultCode.UNKNOWN_ERROR:
        return "UNKNOWN_ERROR"
    default:
        return ""
    }
    return ""
}