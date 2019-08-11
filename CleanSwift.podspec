Pod::Spec.new do |s|
    s.name                      = 'CleanSwift'
    s.version                   = '0.1.0'
    s.summary                   = 'A CleanSwift framework.'
    s.homepage                  = 'https://github.com/marcosmko/CleanSwift'

    s.license                   = { :type => 'MIT', :file => 'LICENSE.md' }
    s.authors                   = { 'Marcos Kobuchi' => 'marcos.kobuchi@undercaffeine.com' }

    s.platform                  = :ios
    s.ios.deployment_target     = '8.0'
    s.source                    = { :git => 'https://github.com/marcosmko/CleanSwift.git', :tag => s.version.to_s }

    s.ios.source_files          = 'Sources/**/*.swift'
    s.swift_versions            = ['4.0', '4.2', '5.0']
end
