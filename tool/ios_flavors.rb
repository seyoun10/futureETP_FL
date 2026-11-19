# iOS 변형(dev·prod) 빌드 구성과 scheme을 만든다(D-043, FL-002). flutter create 직후 한 번만 실행한다.
# Flutter flavor 규칙: 구성 이름 "<Debug|Release|Profile>-<flavor>", scheme 이름 "<flavor>".
# 실행: GEM_HOME=$(echo /opt/homebrew/Cellar/cocoapods/*/libexec) ruby tool/ios_flavors.rb
require 'xcodeproj'
require 'fileutils'

PROJECT = 'ios/Runner.xcodeproj'
BASE_ID = 'io.github.seyoon.futureetp'
FLAVORS = {
  'dev' => { id: "#{BASE_ID}.dev", name: 'futureETP Dev' },
  'prod' => { id: BASE_ID, name: 'futureETP' },
}
BASES = %w[Debug Release Profile]

project = Xcodeproj::Project.open(PROJECT)
lists = [project.build_configuration_list] + project.targets.map(&:build_configuration_list)

lists.each do |list|
  owner_is_runner = project.targets.any? { |t| t.name == 'Runner' && t.build_configuration_list == list }
  BASES.each do |base|
    src = list.build_configurations.find { |c| c.name == base }
    raise "missing #{base}" unless src
    FLAVORS.each do |flavor, v|
      name = "#{base}-#{flavor}"
      next if list.build_configurations.any? { |c| c.name == name }
      cfg = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
      cfg.name = name
      cfg.build_settings = Marshal.load(Marshal.dump(src.build_settings))
      cfg.base_configuration_reference = src.base_configuration_reference
      if owner_is_runner
        cfg.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = v[:id]
        cfg.build_settings['APP_DISPLAY_NAME'] = v[:name]
      end
      list.build_configurations << cfg
    end
  end
  BASES.each do |base|
    src = list.build_configurations.find { |c| c.name == base }
    list.build_configurations.delete(src)
    src.remove_from_project
  end
  list.default_configuration_name = 'Release-prod'
end
project.save

schemes = "#{PROJECT}/xcshareddata/xcschemes"
runner = File.read("#{schemes}/Runner.xcscheme")
FLAVORS.each_key do |flavor|
  xml = runner.gsub(/buildConfiguration = "(Debug|Release|Profile)"/) { %(buildConfiguration = "#{$1}-#{flavor}") }
  File.write("#{schemes}/#{flavor}.xcscheme", xml)
end
FileUtils.rm("#{schemes}/Runner.xcscheme")
puts 'ok'
