# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

class DeployGateConfig
  def initialize(config)
    @config = config
    @user_infomation = false
  end

  def user_id=(id)
    @user_id = id
  end

  def api_key=(key)
    @api_key = key
  end

  def user_infomation=(bool)
    @user_infomation = bool
  end

  def sdk=(sdk)
    @sdk = sdk
    @config.vendor_project(
      sdk,
      :static,
      :products => ['DeployGateSDK'],
      :headers_dir => 'Headers'
    )
    @config.frameworks << 'SystemConfiguration'
    create_launcher
    apply_patch
  end

  private

  def create_launcher
    return unless @user_id && @api_key

    launcher_code = <<EOF
# This file is automatically generated. Do not edit.

NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationDidFinishLaunchingNotification, object:nil, queue:nil, usingBlock:lambda do |notification|
  DeployGateSDK.sharedInstance.launchApplicationWithAuthor('#{@user_id}', key:'#{@api_key}', userInfomationEnabled:#{@user_infomation})
end)
EOF
    launcher_file = './app/deploygate_launcher.rb'
    if !File.exist?(launcher_file) or File.read(launcher_file) != launcher_code
      File.open(launcher_file, 'w') { |io| io.write(launcher_code) }
    end
    @config.files.unshift(launcher_file)
  end

  def apply_patch
    Dir.glob(File.join(@sdk, "Headers") + "/*.h") do |file|
      file = File.expand_path(file)
      data = File.read(file)
      new_data = []
      data.each_line do |line|
        # comment out "@property(nonatomic) DeployGateSDKOption options;" line
        if line.strip == "@property(nonatomic) DeployGateSDKOption options;"
          new_data << "// #{line}"
        else
          new_data << line
        end
      end

      new_data = new_data.join
      if data != new_data
        File.open(file, "w") do |io|
            io.write new_data
        end
      end
    end
  end

end

module Motion; module Project; class Config
  variable :deploygate

  def deploygate
    @deploygate ||= DeployGateConfig.new(self)
  end

end; end; end
