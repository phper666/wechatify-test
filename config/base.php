<?php
use Swoft\Log\Handler\FileHandler;
use Swoft\Log\Logger;

return [
    'name'  => 'Swoft framework 2.0',
    'debug' => env('SWOFT_DEBUG', 1),
    'lineFormatter'      => [
        'format'     => '%datetime% [%level_name%] [%channel%] [%event%] [tid:%tid%] [cid:%cid%] [traceid:%traceid%] [spanid:%spanid%] [parentid:%parentid%] %messages%',
        'dateFormat' => 'Y-m-d H:i:s',
    ],
    'noticeHandler'      => [
        'class'     => FileHandler::class,
        'logFile'   => '@runtime/logs/notice.log',
        'formatter' => \bean('lineFormatter'),
        'levels'    => [
            Logger::NOTICE,
            Logger::INFO,
            Logger::DEBUG,
            Logger::TRACE,
        ],
    ],
    'applicationHandler' => [
        'class'     => FileHandler::class,
        'logFile'   => '@runtime/logs/error.log',
        'formatter' => \bean('lineFormatter'),
        'levels'    => [
            Logger::ERROR,
            Logger::WARNING,
        ],
    ],
    'logger'             => [
        'flushRequest' => true,
        'enable'       => true,
        'flushInterval' => 100,
        'handlers'     => [
            'application' => \bean('applicationHandler'),
            'notice'      => \bean('noticeHandler'),
        ],
    ]
];
