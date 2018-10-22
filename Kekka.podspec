# coding: utf-8
#

Pod::Spec.new do |s|

  s.name         = "Kekka"
  s.version      = "0.7.1"
  s.summary      = "Kekka (結果) means Result. This small framework is inspired from Haskell's monadic types."

  s.description  = <<-DESC
                   This is a small framework with fundamental types like Result and Future
                   which are expressed in pure functional way. This work is inspired by 
                   haskell implementation of monad and its properties. Everything is based on 
                   fundamental reasoning.

                   - Result<T> is a complete Functor and Monad. It is a contextual type over
                   a computation that can pass or fail.

                   - Future<T> (analogous to Promise) is a complete Functor and Monad too. It 
                   abstracts over nested callback and asynchronous API whereby enabling client 
                   to focus as if the completion is given as soon as it is executed.

                   DESC

  s.homepage     = "https://github.com/kandelvijaya/Kekka.git"
  s.license      = "MIT"

  s.author             = { "kandelvijaya" => "kandelvijaya@gmail.com" }
  s.social_media_url   = "http://twitter.com/kandelvijaya"

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/kandelvijaya/Kekka.git", :tag => "#{s.version}" }

  s.source_files  = 'Kekka/Classes/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
