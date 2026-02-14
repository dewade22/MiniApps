using MA.Framework.Core;
using System.Collections.ObjectModel;
using System.Text;

namespace MA.Framework.ServiceInterface.Response
{
#nullable disable

    public class BasicResponse
    {
        #region Fields

        private Collection<Message> _messages;

        #endregion

        #region Properties

        public Collection<Message> Messages => _messages ?? (_messages = new Collection<Message>());

        #endregion

        #region Public Methods

        public bool IsError()
        {
            return Messages.Count(item => item.Type == CoreEnum.MessageType.Error) > 0;
        }

        public bool IsContainInfo()
        {
            return Messages.Count(item => item.Type == CoreEnum.MessageType.Info) > 0;
        }

        public string[] GetMessageTextArray()
        {
            return Messages.Select(item => item.MessageText).ToArray();
        }

        public string[] GetMessageErrorTextArray()
        {
            return Messages.Where(item => item.Type == CoreEnum.MessageType.Error)
                .Select(item => item.MessageText)
                .ToArray();
        }

        public string[] GetMessageInfoTextArray()
        {
            return Messages.Where(IThreadPoolWorkItem => IThreadPoolWorkItem.Type == CoreEnum.MessageType.Info)
                .Select(item => item.MessageText)
                .ToArray();
        }

        public string GetErrorMessage()
        {
            var messageBuilder = new StringBuilder();
            foreach (var message in Messages)
                messageBuilder.AppendLine(message.MessageText);

            return messageBuilder.ToString().Trim();
        }

        public void AddErrorMessage(string message)
        {
            Messages.Add(new Message
            {
                MessageText = message,
                Type = CoreEnum.MessageType.Error,
            });
        }

        public void AddInfoMessage(string message)
        {
            Messages.Add(new Message
            {
                MessageText = message,
                Type = CoreEnum.MessageType.Info,
            });
        }

        #endregion
    }
}
