import {
    Body,
    Controller,
    Get,
    Post,
    UseGuards,
    Request,
  } from '@nestjs/common';
  import { AuthService } from './auth.service';
  import { LocalAuthGuard } from './guards/local-auth.guard';
  import { JwtAuthGuard } from './guards/jwt-auth.guard';
  import { JwtRefreshGuard } from './guards/jwt-refresh.guard';
  import { RegisterDto } from './dto/register.dto';
  import { LoginDto } from './dto/login.dto';
  import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
  
  @ApiTags('auth')
  @Controller('auth')
  export class AuthController {
    constructor(private authService: AuthService) {}
  
    @Post('register')
    @ApiOperation({ summary: 'Inscription d\'un nouvel utilisateur' })
    register(@Body() registerDto: RegisterDto) {
      return this.authService.register(registerDto);
    }
  
    @UseGuards(LocalAuthGuard)
    @Post('login')
    @ApiOperation({ summary: 'Connexion d\'un utilisateur' })
    login(@Body() loginDto: LoginDto, @Request() req) {
      return this.authService.login(req.user);
    }
  
    @UseGuards(JwtAuthGuard)
    @Get('profile')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Obtenir le profil de l\'utilisateur connecté' })
    getProfile(@Request() req) {
      return req.user;
    }
  
    @UseGuards(JwtRefreshGuard)
    @Post('refresh')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Rafraîchir le token d\'accès' })
    refreshTokens(@Request() req) {
      const userId = req.user.id;
      const refreshToken = req.user.refreshToken;
      return this.authService.refreshTokens(userId, refreshToken);
    }
  
    @UseGuards(JwtAuthGuard)
    @Post('logout')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Déconnexion d\'un utilisateur' })
    logout(@Request() req) {
      return this.authService.logout(req.user.id);
    }
  }