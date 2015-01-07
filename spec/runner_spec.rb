require 'spec_helper'

describe XBuild::Runner do

  subject(:xbuild) { XBuild::Runner.new(workspace, scheme, options) }

  let(:project) { "SpecProject" }
  let(:scheme) { project }
  let(:workspace) { "#{project}.xcworkspace" }
  let(:command_executor) { double("command_executor") }
  let(:pretty) { false }
  let(:dry_run) { false }
  let(:action) { XBuild::Runner::ACTIONS.sample }
  let(:options) do
    {
      xctool: build_tool == "xctool",
      command_executor: command_executor,
      pretty: pretty,
      dry_run: dry_run
    }
  end
  let(:command_for_task) do
    ->(task) do
      cmd = "#{build_tool} -workspace #{workspace} -scheme #{scheme} #{task}"
      cmd += " -sdk iphonesimulator" if task == "test"
      cmd
    end
  end

  shared_examples "a build tool runner" do

    XBuild::Runner::ACTIONS.each do |action|

      describe "##{action}" do
        it "executes the #{action} task" do
          expect(command_executor).to receive(:execute).with(command_for_task[action])
          xbuild.send(action)
        end
      end

    end

    describe "#run" do

      context "when the action is valid" do

        it "executes the action" do
          expect(command_executor).to receive(:execute).with(command_for_task[action])
          xbuild.run(action)
        end

        context "when arguments are present" do

          let(:arguments) { {foo: 1, bar:2, baz: nil} }

          it "executes the action with the given arguments" do
            expect(command_executor).to receive(:execute).with(match(/^.* #{action} .*-foo 1 -bar 2 -baz.*$/))
            xbuild.run(action, arguments)
          end

          context "when xbuild was initialized with arguments for the given action" do

            let(:options) do
              {
                xctool: build_tool == "xctool",
                command_executor: command_executor,
                pretty: pretty,
                dry_run: dry_run,
                action_arguments: {
                  action => {
                    :foo => 4,
                    :jaz => nil
                  }
                }
              }
            end

            it "combines both arguments" do
              expect(command_executor).to receive(:execute).with(match(/^.* #{action} .*-foo 1 -jaz -bar 2 -baz.*$/))
              xbuild.run(action, arguments)
            end

          end

        end

        context "when options are present" do

          let(:arguments) { {} }
          let(:build_options) { {foo: 1, bar:2, baz: nil} }

          it "executes the action with the given options" do
            expect(command_executor).to receive(:execute).with(match(/^.* -foo 1 -bar 2 -baz.* #{action}.*$/))
            xbuild.run(action, arguments, build_options)
          end

        end

        context "when the command executor returns true" do

          before(:each) { allow(command_executor).to receive(:execute).and_return(true) }

          it "returns true" do
            expect(xbuild.run(action)).to be_truthy
          end

        end

        context "when the command executor returns false" do

          before(:each) { allow(command_executor).to receive(:execute).and_return(false) }

          it "returns false" do
            expect(xbuild.run(action)).to be_falsy
          end

        end

        context "when XBuild's option 'dry_run' is true" do

          let(:dry_run) { true }

          it "does not call the command executor" do
            expect(command_executor).not_to receive(:execute)
          end

        end

      end

      context "when the action is invalid" do

        it "raises an error" do
          expect { xbuild.run("foo") }.to raise_error("Invalid action foo")
        end

      end

    end

  end

  context "when using xctool as the build tool" do

    let(:build_tool) { "xctool" }
    it_behaves_like "a build tool runner"

  end

  context "when using xcodebuild as the build tool" do

    let(:build_tool) { "xcodebuild" }
    it_behaves_like "a build tool runner"

    describe "#run" do

      context "when XBuild's option 'pretty' is true" do

        let(:pretty) { true }

        it "uses xcpretty to format the output" do
          expect(command_executor).to receive(:execute).with(match(/^set -o pipefail && xcodebuild .* | xcpretty -c$/))
          xbuild.run(action)
        end

      end

    end

  end

end
