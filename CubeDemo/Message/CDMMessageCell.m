//
//  CDMMessageCell.m
//  CubeDemo
//
//  Created by jerny on 13-8-15.
//  Copyright (c) 2013年 yglh. All rights reserved.
//

#import "CDMMessageCell.h"
#import "UIImageView+WebCache.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation CDMMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleBg =[[UIImageView alloc] initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc] initWithFrame:CGRectZero];
        _messageTimeStamp = [[UILabel alloc] initWithFrame:CGRectZero];
        _headMask =[[UIImageView alloc] initWithFrame:CGRectZero];
        _chatImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadingImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [_videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _playerVC = [[MPMoviePlayerViewController alloc]init];
//        _playerVC.view.frame = CGRectZero;
        
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        [_messageTimeStamp setBackgroundColor:[UIColor clearColor]];
        [_messageTimeStamp setFont:[UIFont systemFontOfSize:10]];
        [progressLabel setBackgroundColor:[UIColor clearColor]];
        [progressLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
        [self.contentView addSubview:_loadingImage];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_messageTimeStamp];
        [self.contentView addSubview:progressLabel];
        [self.contentView addSubview:_chatImage];
        [self.contentView addSubview:_voiceBtn];
        [self.contentView addSubview:_videoBtn];
//        [self.contentView addSubview:_playerVC.view];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self setBackgroundColor:[UIColor clearColor]];
        
//        [self startLoadingImage];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *orgin=_messageConent.text;

    CGSize textSize;
    
    if ([orgin respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary * attributes = @{NSFontAttributeName : _messageConent.font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        textSize = [orgin boundingRectWithSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) options:NSStringDrawingUsesFontLeading
                            |NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [orgin sizeWithFont:_messageConent.font
                                         constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:_messageConent.lineBreakMode];
#pragma clang diagnostic pop
        
    }
    
    NSString *timeStamp = _messageTimeStamp.text;
    CGSize timeSize;
    if ([timeStamp respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary * attributes = @{NSFontAttributeName : _messageTimeStamp.font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        timeSize = [timeStamp boundingRectWithSize:CGSizeMake(320, 10) options:NSStringDrawingUsesFontLeading
                    |NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        timeSize = [timeStamp sizeWithFont:_messageConent.font
                     constrainedToSize:CGSizeMake(320, 10) lineBreakMode:_messageConent.lineBreakMode];
#pragma clang diagnostic pop
    }
    
    switch (_messageObject.msgStyle) {
        case KMessageCellStyleMe:
        {
//            _playerVC.view.hidden = YES;
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:YES];
            [_loadingImage setHidden:YES];
            [_voiceBtn setHidden:YES];
            [_videoBtn setHidden:YES];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_male"];
            [_bubbleBg setHidden:NO];
             [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
            [_headMask setHidden:NO];
        }
            break;
        case KMessageCellStyleOther:
        {
            [_chatImage setHidden:YES];
            [_loadingImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:YES];
            [_voiceBtn setHidden:YES];
            [_videoBtn setHidden:YES];
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_female"];
            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
            [_headMask setHidden:NO];
        }
            break;
        case KMessageCellStyleMeWithImage:
        {
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_chatImage setHidden:NO];
            [_loadingImage setHidden:YES];
            [_messageConent setHidden:YES];
            [progressLabel setHidden:NO];
            progressLabel.frame = CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-155, (CELL_HEIGHT-100)/2, 40, 20);

            [_messageTimeStamp setHidden:YES];
            [_voiceBtn setHidden:YES];
            [_videoBtn setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_male"];
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(progressLabel.frame.origin.x-15, _chatImage.frame.origin.y-12, 140+30, 100+30);
            [_headMask setHidden:NO];
        }
            break;
            case KMessageCellStyleOtherWithImage:
        {
            [_chatImage setHidden:NO];
            [_loadingImage setHidden:YES];
            [_messageConent setHidden:YES];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:NO];
            progressLabel.frame = CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2, 40, 20);
            [_voiceBtn setHidden:YES];
            [_videoBtn setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15+progressLabel.frame.size.width, (CELL_HEIGHT-100)/2,100,100)];
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_female"];
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];

            _bubbleBg.frame=CGRectMake(progressLabel.frame.origin.x-15, _chatImage.frame.origin.y-12, 140+30, 100+30);
            [_headMask setHidden:NO];

        }
            break;
        case KMessageCellStyleMeWithVoice:
        {
            [_chatImage setHidden:YES];
            [_loadingImage setHidden:YES];
            [_messageConent setHidden:YES];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:YES];
            [_voiceBtn setHidden:NO];
            [_videoBtn setHidden:YES];
//            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            _voiceBtn.frame = CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-55, (CELL_HEIGHT-10)/2, 40, 40);
//            _voiceBtn.frame = _messageConent.frame;
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_male"];
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_voiceBtn.frame.origin.x-15, _voiceBtn.frame.origin.y-12, 40+30, 40+30);
            [_headMask setHidden:NO];
        }
            break;
        case KMessageCellStyleOtherWithVoice:
        {
            [_chatImage setHidden:YES];
            [_loadingImage setHidden:YES];
            [_messageConent setHidden:YES];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:YES];
            [_voiceBtn setHidden:NO];
            [_videoBtn setHidden:YES];
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_female"];
            _voiceBtn.frame = CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-10)/2,40,40);
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_voiceBtn.frame.origin.x-15, _voiceBtn.frame.origin.y-12, 40+30, 40+30);
            [_headMask setHidden:NO];
            
        }
            break;
            case kmessagecellstyleMeWithVideo:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:YES];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:NO];
            [_loadingImage setHidden:NO];
            progressLabel.frame = CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-155, (CELL_HEIGHT-100)/2, 40, 20);
            _loadingImage.frame = CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-155, 40, 20, 20);
            [self startLoadingImage];
//            [_loadingImage startAnimating];
            [_voiceBtn setHidden:YES];
            [_videoBtn setHidden:NO];
            _videoBtn.frame = CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100);
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_male"];
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame = CGRectMake(progressLabel.frame.origin.x-15, _videoBtn.frame.origin.y-12, 140+30, 100+30);
            [_headMask setHidden:NO];
            
        }
            break;
            
            case kmessagecellstyleOtherWithVideo:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:YES];
            [_messageTimeStamp setHidden:YES];
            [progressLabel setHidden:NO];
            [_voiceBtn setHidden:YES];
            [_videoBtn setHidden:NO];
            progressLabel.frame = CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2, 40, 20);
            [_videoBtn setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15+progressLabel.frame.size.width, (CELL_HEIGHT-100)/2,100,100)];
//            [_videoBtn setFrame:CGRectMake(100, 100,100,100)];
            [_userHead setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            _userHead.image = [UIImage imageNamed:@"person_head_female"];
            [_bubbleBg setHidden:NO];
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            _bubbleBg.frame=CGRectMake(progressLabel.frame.origin.x-15, _videoBtn.frame.origin.y-12, 140+30, 100+30);
            [_headMask setHidden:NO];

        }
            break;
        case KMessageCellStyleTimeStamp:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:YES];
            [_messageTimeStamp setHidden:NO];
            [_messageTimeStamp setFrame:CGRectMake((self.contentView.frame.size.width - timeSize.width) / 2, (CELL_HEIGHT - timeSize.height) / 2, timeSize.width, timeSize.height)];
            [_voiceBtn setHidden:YES];
            [_userHead setHidden:YES];
            [_bubbleBg setHidden:YES];
            [_headMask setHidden:YES];
        }
        case KMessageCellStyleSendFile:
        {
            //TODO
        }
        case KMessageCellStyleReceiveFile:
        {
            //TODO
        }
            break;
        default:
            break;
    }
    
    _headMask.frame = CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}
- (void)startLoadingImage
{
//    _loadingArr = [[NSMutableArray alloc] init];
//    for (int i = 1; i < 5; i ++) {
//        NSString *imageName = [NSString stringWithFormat:@"loading%d.png",i];
//        UIImage *image = [UIImage imageNamed:imageName];
//        [_loadingArr addObject:image];
//    }

//    _loadingImage.animationImages = _loadingArr;
    _loadingImage.animationImages = _messageObject.loadingArray;
    
    if (_loadingImage.animationImages.count != 0) {

        _loadingImage.animationDuration = 0.3;
        [_loadingImage startAnimating];
    }else{
        [_loadingImage stopAnimating];
    }
    
    

}
#pragma mark 声音按钮点击
-(void)voiceBtnClick:(UIButton *)sender
{
    [[[CubeEngine sharedSingleton] getMediaController] playRecordVoice:_messageObject.filePath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageObject:(CDMMessageObject *)messageObject
{
    _messageObject = messageObject;
    _messageConent.text = messageObject.message;
    _messageTimeStamp.text = messageObject.timeStamp;
//    [_chatImage setImage:messageObject.image];
    [_chatImage setImage:messageObject.image forState:UIControlStateNormal];
    [_voiceBtn setImage:messageObject._voiceBtn forState:UIControlStateNormal];
    [_videoBtn setImage:messageObject._videoBtn forState:UIControlStateNormal];
    progressLabel.text = messageObject.progress;
//    _loadingImage.animationImages = messageObject.loadingArray;
    
}

@end
